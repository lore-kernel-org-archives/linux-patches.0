Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9388119755E;
	Thu,  5 Sep 2024 09:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529632; cv=none; b=NrNYiqtH1jP0t5Hk6HkOj07hNOm+JHpACmXREq24RWVDN88T2tt5r7pBA2LmEGwfuCLEn4oTaqWEvPErlDd29s6kl6PjYizubRNLzFMzYGnlqp3iyI07lR9QXczaK+F5ArriQeRg9LgIbL7l/HYTms0cgzH/Fs9nHSgg0I8ZmYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529632; c=relaxed/simple;
	bh=Ncw/DFeXsJSPewS5UvhzM3JFH0iUqxMgwxlGHX1Ok/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jX7fiF1Z78icr6wtIGTA7FQrmuQcTIDLQC3scbuZyi4ikEAr+htkjqaVbON7zkHNSrpNB3W8kszCbUtS7nic4WFOyveG7F29F+RI5dEIjE/+3203LMu1VTZTsjRQpDX3o6wgrouDrzdygrEClJWKP5/fUVohd9Op9Hkd4Vx1j/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKu0do1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKu0do1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D23C4CEC3;
	Thu,  5 Sep 2024 09:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529632;
	bh=Ncw/DFeXsJSPewS5UvhzM3JFH0iUqxMgwxlGHX1Ok/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKu0do1K3eRO45fg19sU96y8gbO5YwiAXhWI4CZxg3Q44IpObHs/sKEnqlY3wvHr5
	 L0ZIkeCc08V7B/oB9vYnLSLybIhssxM6xOcRc7urigWE7JoiHkPNwHHQbwARBRyIF3
	 tCXVaqMAyi34bh281Qyyq4jxod1ep14CHlydjKMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 063/184] drm/amd/display: Add missing NULL pointer check within dpcd_extend_address_range
Date: Thu,  5 Sep 2024 11:39:36 +0200
Message-ID: <20240905093734.699755374@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hersen Wu <hersenxs.wu@amd.com>

[ Upstream commit 5524fa301ba649f8cf00848f91468e0ba7e4f24c ]

[Why & How]
ASSERT if return NULL from kcalloc.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/link/protocols/link_dpcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dpcd.c b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dpcd.c
index a72c898b64fa..584b9295a12a 100644
--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_dpcd.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_dpcd.c
@@ -165,6 +165,7 @@ static void dpcd_extend_address_range(
 		*out_address = new_addr_range.start;
 		*out_size = ADDRESS_RANGE_SIZE(new_addr_range.start, new_addr_range.end);
 		*out_data = kcalloc(*out_size, sizeof(**out_data), GFP_KERNEL);
+		ASSERT(*out_data);
 	}
 }
 
-- 
2.43.0



