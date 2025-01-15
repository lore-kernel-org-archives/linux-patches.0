Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E04248BB1;
	Wed, 15 Jan 2025 10:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937675; cv=none; b=RxoUqWxtzJASEmY0fsnL05jqjDF1eTHeYDYdUHqlCoRb0J63ALwsbKLMuHzQ/+rS4wjQp8yo7qDzKjt89LQalK3ZAqlDo4beLlU4LmXLjeGkw7+7pkDm+Zyu+5OI7fPJDy7z5SEU3jk5bA7H+tlLRn+JucB3+QwC6WlL/q6+35Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937675; c=relaxed/simple;
	bh=wEw7xShPyizmJeq25bAO0QN78p8Fc8PPgQ9HE9DvSRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8EjZ2P+n7dlk0cuizl75gSRfVRIzZxWP03jb0gqbqi/Np38IwzQA/Qc9AJbGngv//IWmFu/EPxX2kGrSrhxcIJcgOJ7QS32Fv0/omQaMDjc+P5tcG7CmzszNfrez8ghVpfOjO5u97AdemSnqc0FI31sWA1DpPahc1e6TomrXpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJyKfAov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJyKfAov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956ADC4CEE4;
	Wed, 15 Jan 2025 10:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937675;
	bh=wEw7xShPyizmJeq25bAO0QN78p8Fc8PPgQ9HE9DvSRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJyKfAov4rqYPqioDNMNJigONjlnvohn2Tj1y9yfNOH2trf6iKmXmVltQU0Vz3Fa1
	 LLr9Taz9JT9y0Aog1fQOENRSsUw9h67TGgbW2RpIfdeH2BkO+eKTcb3B0oM0Wvv/aS
	 cQW62vSpVXUxjep4gYrxQMM4Tq4qbGOmfgGmZtgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 48/92] drm/amd/display: increase MAX_SURFACES to the value supported by hw
Date: Wed, 15 Jan 2025 11:37:06 +0100
Message-ID: <20250115103549.454153726@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

commit 21541bc6b44241e3f791f9e552352d8440b2b29e upstream.

As the hw supports up to 4 surfaces, increase the maximum number of
surfaces to prevent the DC error when trying to use more than three
planes.

[drm:dc_state_add_plane [amdgpu]] *ERROR* Surface: can not attach plane_state 000000003e2cb82c! Maximum is: 3

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/3693
Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b8d6daffc871a42026c3c20bff7b8fa0302298c1)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dc.h
+++ b/drivers/gpu/drm/amd/display/dc/dc.h
@@ -49,7 +49,7 @@ struct dmub_notification;
 
 #define DC_VER "3.2.207"
 
-#define MAX_SURFACES 3
+#define MAX_SURFACES 4
 #define MAX_PLANES 6
 #define MAX_STREAMS 6
 #define MAX_SINKS_PER_LINK 4


