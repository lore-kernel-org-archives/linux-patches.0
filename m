Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E7B1E9906;
	Wed, 15 Jan 2025 10:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938308; cv=none; b=nP05sNhWh3VhlPSG8vonNw1UcW0HTX9AjQQwqjKLKzkbY/t8qBdm84C2CFHw2/YvNaAAvRyDU5HJvwLr3aYY/zPQE3MZ3iQnA6g/Lgjsh+ONt7EcWXesMUpOxCzN37kQkKpL4wktEjrcoyqz8zDQQLlwyXLvNCPbXgEoS/cL8fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938308; c=relaxed/simple;
	bh=x9RyD+0YW0Jt3hO3Gxxmi58mHHjWso56SXd+gbdCOX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4sPHJlCaiEwBYU7dShuZhNAXPVGS0e7d1r3Yoal5H+SY9qSDVUKvPuzfbMC0i8GcZLBzBeQ8NCOpFfaBQMU3BR3hirw8DKnCpH/uJ7HTIgPMjVhBHmFdwA6boXdDgc6SOaoGiX8bDCyerEKsImrOEvxwzgFEpfrDAiacGohJUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/Z1LfIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/Z1LfIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D0EC4CEE8;
	Wed, 15 Jan 2025 10:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938308;
	bh=x9RyD+0YW0Jt3hO3Gxxmi58mHHjWso56SXd+gbdCOX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/Z1LfIRkTZjirwRyLn7+lcXitcYcw+hqJH3/oL5bcbQYRKc8e1sjrQM3ciQd1NLM
	 3ZgRB1IDOEWfRo6Iodi0uZN1RETFJuXv1rGWlU0NIp6mzDtyoM3WGgG41sQ07Dr/Rq
	 dvIQUjxR816KxcDyzacIm9Ll1heWStqExy1He4V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 127/189] drm/amd/display: increase MAX_SURFACES to the value supported by hw
Date: Wed, 15 Jan 2025 11:37:03 +0100
Message-ID: <20250115103611.510268843@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -57,7 +57,7 @@ struct dmub_notification;
 
 #define DC_VER "3.2.301"
 
-#define MAX_SURFACES 3
+#define MAX_SURFACES 4
 #define MAX_PLANES 6
 #define MAX_STREAMS 6
 #define MIN_VIEWPORT_SIZE 12


