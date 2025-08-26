Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADE2393DD1;
	Tue, 26 Aug 2025 11:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208461; cv=none; b=AtBjOOp3LQ1E9RiiaMdSJ9zxSI+2SZS1VeVFjisHjomM945y4x6vr4B457LUqd2tzvoysH7TLSewi7BsjWL3R6SvkFZlpzu0OQH7OIXByOusbP8s8+eLRy7KLCItIxVwRaw4Y4WvNdcpHlDli1j0vTZZHbmiS4y3RRsV8s3y2e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208461; c=relaxed/simple;
	bh=R2CsOUabmboLXrelTc+bAYDvVi7/6sUI7VJqVWkh5zA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctfxXyeKLzRLtE/p8FWtxZmvsXQ8ODOkx9HNKdbXzMZc6EUx4mVfnYL1PAEnZeycB5jBLo7Yo665rnLxWwzLDIo3dZcY/3uMGtpRBbgrLpjWzHKT8h1NogM0LuY9cs3pvgqgD2IddQwKG2x1Y64QiSrn7Lh2P9kNaEnVHZRIwKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Weac0XlL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Weac0XlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6927DC4CEF1;
	Tue, 26 Aug 2025 11:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208461;
	bh=R2CsOUabmboLXrelTc+bAYDvVi7/6sUI7VJqVWkh5zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Weac0XlLhMIQggaY1dxjFuY94QlDyHeHj2VL2qOk38waXyO2RbPUIYrV748G7ceha
	 rwVi2EPRBjT1DlHSuInF1k4RZb+YtED8fmVCsIp9yQ+ejBGSZWW0iCIg7vuY0QIwPX
	 JD4/nSCXAG0Si8dKGrQtcIfoCOfC25D4th26AQN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Shkenev <mustela@erminea.space>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 121/322] drm/amdgpu: check if hubbub is NULL in debugfs/amdgpu_dm_capabilities
Date: Tue, 26 Aug 2025 13:08:56 +0200
Message-ID: <20250826110918.787932169@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Peter Shkenev <mustela@erminea.space>

commit b4a69f7f29c8a459ad6b4d8a8b72450f1d9fd288 upstream.

HUBBUB structure is not initialized on DCE hardware, so check if it is NULL
to avoid null dereference while accessing amdgpu_dm_capabilities file in
debugfs.

Signed-off-by: Peter Shkenev <mustela@erminea.space>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -3932,7 +3932,7 @@ static int capabilities_show(struct seq_
 
 	struct hubbub *hubbub = dc->res_pool->hubbub;
 
-	if (hubbub->funcs->get_mall_en)
+	if (hubbub && hubbub->funcs->get_mall_en)
 		hubbub->funcs->get_mall_en(hubbub, &mall_in_use);
 
 	if (dc->cap_funcs.get_subvp_en)


