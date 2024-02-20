Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40B3612D7;
	Tue, 20 Feb 2024 21:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463844; cv=none; b=apSqNFNcWUyRzpAxkYXjWXUr2jldJFpfrw0yyGcxmj6xa+rrx+kvK+1arLhF8APAUqMtheUo6cvuKLiEnrLHz3dg2v+g8nLCn/4/9XVdRKxM0rGA+32+0a2P79vjpA/XxewFIl6C4k8fMTqqP9LEeAIirLAFiTSglkQQ2KNIMOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463844; c=relaxed/simple;
	bh=G+z8Drw4Bw9RJJSmOIFn+glbmIWSpIRL+4nD3t20jeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZERx7kh5Hu0Y0qqtjw0QYXVsgcvzxz/1T4KYbDrQgLIclWf3g53/nlaulF8o/x/I8+sWBBzh6pUYQM2HclwW65X3dXRBFDCuv1uDpkWg76UgJ92gEOcNraiLoRksU8EWFiBcGNyDcYF8nThyXyDyfTXhTn74KwXXdXg61HXwzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWuSbYwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWuSbYwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52505C433F1;
	Tue, 20 Feb 2024 21:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463843;
	bh=G+z8Drw4Bw9RJJSmOIFn+glbmIWSpIRL+4nD3t20jeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWuSbYwdccR2VIWps+2duJlsZsUGyTGAJWCwjPRvunT5elMegu6+NVHvRoVDO7aLi
	 ZBsRck0QD30HMBs0W+UdJW7SGSKTlHWimLqty+r4+VPdSA5QiPgRyCWjdmPhS5Egrh
	 JO95xNKkI4tYNipnNQkedbG5gnWqQ9/KW9TPyg/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thong <thong.thai@amd.com>,
	Ruijing Dong <ruijing.dong@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 170/331] drm/amdgpu/soc21: update VCN 4 max HEVC encoding resolution
Date: Tue, 20 Feb 2024 21:54:46 +0100
Message-ID: <20240220205642.859767948@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thong <thong.thai@amd.com>

commit 2f542421a47e8246e9b7d2c6508fe3a6e6c63078 upstream.

Update the maximum resolution reported for HEVC encoding on VCN 4
devices to reflect its 8K encoding capability.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3159
Signed-off-by: Thong <thong.thai@amd.com>
Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -50,13 +50,13 @@ static const struct amd_ip_funcs soc21_c
 /* SOC21 */
 static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_encode_array_vcn0[] = {
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2304, 0)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 2304, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_AV1, 8192, 4352, 0)},
 };
 
 static const struct amdgpu_video_codec_info vcn_4_0_0_video_codecs_encode_array_vcn1[] = {
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_MPEG4_AVC, 4096, 2304, 0)},
-	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 4096, 2304, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 0)},
 };
 
 static const struct amdgpu_video_codecs vcn_4_0_0_video_codecs_encode_vcn0 = {


