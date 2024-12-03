Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44995153800;
	Tue,  3 Dec 2024 15:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240831; cv=none; b=MZDsPsAwGRKebGr9X7fjS69XSrC3TuIGb5w00lKqtnBxRIUBHReBl1Nhi+L8Rt7FZ/Blhsa2+BYFDqg9/I0cpOA4Uvl6NHT8cy/u/xvLwecWoTQ38+xyFFIGqLiYpVycfbU8/IUvEr1v4nrn2LrYEamnFYyNaGAO56U1YzQcPBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240831; c=relaxed/simple;
	bh=7uX7HlAh6tkDKddRJ60HVvO33gkEl+ZJ/QMH/Lr1P0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJdksmfFVYNzJ1dv9Y7Uyob7OY3jsvgH7js1/5TmnN+c7mnyORCZq+eqK1hfnQzJ3dqBIBTLWIg9OYi3Uwgj8v8V6pQUXc5EIm399LB5ZQmCd3gYDVSuyaXU311w4WEG4KUlSovpS7+YXjutAaK8ZTupg0oP/uftCfQx0XQgl6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrCAv71+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrCAv71+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DC6C4CECF;
	Tue,  3 Dec 2024 15:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240831;
	bh=7uX7HlAh6tkDKddRJ60HVvO33gkEl+ZJ/QMH/Lr1P0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrCAv71+DpVOqniuocPC0bpIf+cUnHyfhngLrrXkYPuDJXA4gzHJC4jgU4WhXLRck
	 OI+hJ6kRMCodJxiEihFSWKZoUxYjwyHC77l+r/WA0hzT8qWaVXYOXj6es1A0rovoaN
	 22obRgPkolmE85oAfqoFCN75VKYApSCCVFyf2qwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 248/826] drm/panic: Select ZLIB_DEFLATE for DRM_PANIC_SCREEN_QR_CODE
Date: Tue,  3 Dec 2024 15:39:35 +0100
Message-ID: <20241203144753.440081605@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 2ad84af4cff9121827d3dd35e293478bdb0b58bb ]

Under `CONFIG_DRM_PANIC_SCREEN_QR_CODE=y`, zlib is used:

    ld.lld: error: undefined symbol: zlib_deflate_workspacesize
    >>> referenced by drm_panic.c
    >>>               drivers/gpu/drm/drm_panic.o:(drm_panic_qr_init) in archive vmlinux.a

Thus select `CONFIG_ZLIB_DEFLATE`.

Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241003230734.653717-1-ojeda@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 1cb5a4f192933..cf5bc77e2362c 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -152,6 +152,7 @@ config DRM_PANIC_SCREEN
 config DRM_PANIC_SCREEN_QR_CODE
 	bool "Add a panic screen with a QR code"
 	depends on DRM_PANIC && RUST
+	select ZLIB_DEFLATE
 	help
 	  This option adds a QR code generator, and a panic screen with a QR
 	  code. The QR code will contain the last lines of kmsg and other debug
-- 
2.43.0



