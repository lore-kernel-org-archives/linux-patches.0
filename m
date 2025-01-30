Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A761E522;
	Thu, 30 Jan 2025 14:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246940; cv=none; b=ZG8YAmH+J4G3DxsONq6Lhh0nN6td+NnvX4KDck1a+ZEvXY4BTrjeLcc1Or2dSl1/gok0jQOEf22zF+/nA+WCEUDs0jy3bmsY+kCFWlHtC4lZ9R3LNb7MoZrWJpPUVAhCyQUDEiTDnrTyERGXxmcFFMbpmHTk1FdaZyYiV2Aq9LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246940; c=relaxed/simple;
	bh=+UU62Kgc4kuZx9XbOUBMLdSv5WGiPDJ9VvZjaSOiKYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoliB8Y2sCV+okLUiVshPJVfpoAD0tSmkSh8+1W3IRi/88IzPtaKfduQKPOAQdeZaPcGg12ypZB0mvmrdfGH5NzGlGx+g79F1wfSd3nIciN85cU03NnB8w8ML9CFqOcs4Go8McLgWZjfOhDlJOBT5Tlbqo3iTjXVBKw1bWvMPa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6Ro7lAQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6Ro7lAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C3EC4CED2;
	Thu, 30 Jan 2025 14:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246940;
	bh=+UU62Kgc4kuZx9XbOUBMLdSv5WGiPDJ9VvZjaSOiKYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z6Ro7lAQ20ujF3uWutvEdFhWz+IN+bklL21SL96kWgATnhrsXHF3a3ndIPwjzaf4M
	 5mKWJimI2IyqSNXNk4mchXYrFoAJizgdXjwqWAoYwpaYcp2JfSBieIMzV4F8hUTt1p
	 ntDTr/a+llrtGSdZUI+MYbXp9v4I4KtMiBdK/IxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 027/133] drm/amd/display: increase MAX_SURFACES to the value supported by hw
Date: Thu, 30 Jan 2025 15:00:16 +0100
Message-ID: <20250130140143.606061889@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -44,7 +44,7 @@
 
 #define DC_VER "3.2.104"
 
-#define MAX_SURFACES 3
+#define MAX_SURFACES 4
 #define MAX_PLANES 6
 #define MAX_STREAMS 6
 #define MAX_SINKS_PER_LINK 4


