Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E679C13D;
	Thu, 30 Jan 2025 14:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245691; cv=none; b=c9bVUYl7epes2DIeQHNqIUmEDl6Z6AcoJ3svxrdhuhe4XiTpXwuWC6h4jMcIMwzVRNhwoWcOLqGPFtekpqS1H/OBRYLGz8Uzt63JQBbdPsaAxvC2cD7JAfmYM7sg0ujkiXT7r8dCNAWkieMdFBLUsXTmZ+HCYH1r4AfS2IbKZMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245691; c=relaxed/simple;
	bh=hoFzjedfnoq/56QprmeLuSidtMl6DaafCsyYVVd+zAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaD9Px0CaGxv1uqAUHsDMfI6eFyeeyhotBptL5Leh26TSjr2GSYhwZVI440ggeaiHu/iNINYrgyIWmbf9v25E5ZxAcLzh9TEw/CHj7e8dAgX8taQxbuRfkDQc37K7LxT/1M7QbsJtYNJvGaXWZuUc0e2mGyu68qNbDJaSHpv7+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRn/7QsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRn/7QsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87BFC4CED2;
	Thu, 30 Jan 2025 14:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245691;
	bh=hoFzjedfnoq/56QprmeLuSidtMl6DaafCsyYVVd+zAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRn/7QsGKyaz5R2v8fnT202Fp2OP0NEjPU0MfSCtG8SUX4VE/UOBRMw9E3RpNDLfp
	 K9SuFd1K9025S2AoXFsPygh7sq25QbdmkkgNNuZzSAaWz0jfBo/Zn8XhMW8KQpfuyF
	 49CPsWUJ+KkpYdn5YT3ppCI/LIJ7QIr7InZOJrq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Austin Zheng <austin.zheng@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 08/40] drm/amd/display: Initialize denominator defaults to 1
Date: Thu, 30 Jan 2025 14:59:08 +0100
Message-ID: <20250130133500.047477297@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 36b23e3baf9129d5b6c3a3a85b6b7ffb75ae287c ]

[WHAT & HOW]
Variables, used as denominators and maybe not assigned to other values,
should be initialized to non-zero to avoid DIVIDE_BY_ZERO, as reported
by Coverity.

Reviewed-by: Austin Zheng <austin.zheng@amd.com>
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e2c4c6c10542ccfe4a0830bb6c9fd5b177b7bbb7)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c        | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
index 3ea54fd52e468..e2a3764d9d181 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
@@ -578,8 +578,8 @@ static void CalculateBytePerPixelAndBlockSizes(
 {
 	*BytePerPixelDETY = 0;
 	*BytePerPixelDETC = 0;
-	*BytePerPixelY = 0;
-	*BytePerPixelC = 0;
+	*BytePerPixelY = 1;
+	*BytePerPixelC = 1;
 
 	if (SourcePixelFormat == dml2_444_64) {
 		*BytePerPixelDETY = 8;
-- 
2.39.5



