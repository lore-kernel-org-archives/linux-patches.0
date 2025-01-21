Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99411F5439;
	Tue, 21 Jan 2025 18:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482865; cv=none; b=Nw96Wg57rBOUnwen97g9gZO21Ny81URuCko9LtKUBI9AdgeLTBI2t0bcwT/YNw1yYoASwgDw3xldof7/666V4Qp/a2+jZCZzl2fLfdyPPL1NiuJ5l8Ttfq4lpDDnW4xPjSoViCkI+BJmKy2+EAkhgACFbqkjXjBdY2aRKrDsDT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482865; c=relaxed/simple;
	bh=SvHFDnB59H2/VqgMwt2fCZSYD57ee/tT517BonVQo2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0e7pd6q0gq2MPhD9iS9OdE9PP5GqAQCfJgUTU1R/GpivqARPyEyYTOfcnQjbZ9Rw8lCnkouF+Gwexcak+IzCHE8il2ZfZbg15u5kJvn6KndaP+PgcQ+T5PjvhyNV7Gec8qQaXWnrikq+JRxQ2OxvABTp5dODUK29+y+bTHRPME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEGgijlS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEGgijlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DAAC4CEDF;
	Tue, 21 Jan 2025 18:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482863;
	bh=SvHFDnB59H2/VqgMwt2fCZSYD57ee/tT517BonVQo2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEGgijlSgmI2vnVauznMJGBAUSqCmPo44obLD6+2bdNx25MEraYqCtjuZ0YyW6dRK
	 j2orPzWcW0kuQ9V1Y6clvsTNYRZtaaJSqwNQcSq3L1+qKtlEVocekVX298LCnw9h9m
	 jijE3b5p2cyrF62Iu6EN5kGfFuaDGhfaxLa9qRoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 033/127] drm/amd/display: increase MAX_SURFACES to the value supported by hw
Date: Tue, 21 Jan 2025 18:51:45 +0100
Message-ID: <20250121174530.963029880@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -47,7 +47,7 @@ struct aux_payload;
 
 #define DC_VER "3.2.149"
 
-#define MAX_SURFACES 3
+#define MAX_SURFACES 4
 #define MAX_PLANES 6
 #define MAX_STREAMS 6
 #define MAX_SINKS_PER_LINK 4


