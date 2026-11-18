Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053252;
	b=UWBsuF38lQWlRNNc/jR0XP7wLLIQ5N6HXZrIFUNrkrk2NkJgVjMc063SB85f6zkcB3Jy
	 +qDvRpVD/lDPEM50Kg0jFDy0yDX2n7h8lVBFf2pR5hAZ74LMPy6kGwQmHbSbCTvvnXe7m
	 ECDHYLMIdDymFQmH8qWKlq2ARv8YZ3PsF5lWl0sMRM4xwSyWSXTTfIjiDNYrlhff0McEl
	 87e/cg0vIqC0bh/336zNvErOfQez08OLPlMe/4hHJJw0bz09cRppA2fuHQS5MB7sx+cwf
	 yCuR1LQSf6/GVVXfJQS1kcLkNjkVkZ79dVGuVDiCIN4H0SlTPIFD6nF1m/2Jf2DaqUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LsVLTJobFBDk45vA4rM76Zf6jh7cB8Q1oYCaggckS0s=;
	b=xOxt93mDiYBpnUXRpQ6tGPNAftoxLEL/SGDLNESdg0w7tJ3OJucs5AVyNJ/6XjNNx9tS
	 49CjeiYlVCuu6Sw2MypDVFQkJAmOLU6TaBWRQ5L/XhSVWyj8w7g/gRV+1eh5qLPy4/WXi
	 if2nNInLZbvaerKf+z9RP6TYtri5cP++nPYD3ugYMsNgfjy98ESoPu4QRxPFBylwk3e5E
	 8TGqF8tzJRvzh3qOf71etEP6mxu3taws82x+WnmlYn6atDvrSxtLLvI7W/HgbeQwvig61
	 74XTgN1sFRGe/kF9SO03/lc0obEgH0jfV6uiDDwD6WqZYUpVmZk5hX9hcuDfh7E0qWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=StXQrrVO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10174606A32C;
	Thu, 19 Nov 2026 01:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=StXQrrVO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296381F000C4;
	Thu, 19 Nov 2026 01:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053251;
	bh=LsVLTJobFBDk45vA4rM76Zf6jh7cB8Q1oYCaggckS0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=StXQrrVOhVCj68qlGfGX7R/d2SaCFe6EtuaoHLAXLiz8VMS9SyVrgfILJHKhOhEoD
	 bUtHDa7wYLBOK7L0mRjeTVrBDS//OGaw7hglwu0YCPELQ3d8tPljCF9V2vD86CU1tK
	 9CbFRD0/SNwAZd/GyAn8fJKPl4OyZaJsCIIiDkW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0854/2214] scsi: target: tcmu: Fix divide-by-zero in data_pages_per_blk store
Date: Wed, 18 Nov 2026 15:42:10 +0100
Message-ID: <20261118150046.341730885@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shao Mingyin <shao.mingyin@zte.com.cn>

[ Upstream commit b8d0bb6a8ba0d3878940a914a19336844101867b ]

tcmu_set_data_pages_per_blk() only validates the upper bound of the value
parsed from data_pages_per_blk=. Zero passes that check and is then used as
the divisor when computing udev->max_blocks:

  divide error: 0000 [#1] SMP
  ...
  tcmu_set_data_pages_per_blk
  tcmu_configure_device

Reject non-positive values, as the neighbouring max_data_area_mb and
cmd_ring_size setters already do.

Fixes: 08976cb548d6 ("scsi: target: tcmu: Make data_pages_per_blk changeable via configfs")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Cc: stable@vger.kernel.org
Reviewed-by: Bodo Stroesser <bostroesser@gmail.com>
Link: https://patch.msgid.link/20261026195245337ktSXy9G17VCcXyw760g9s@zte.com.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 7a467b1f9099b..1269804573fb1 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2513,6 +2513,11 @@ static int tcmu_set_data_pages_per_blk(struct tcmu_dev *udev, substring_t *arg)
 		return ret;
 	}
 
+	if (val <= 0) {
+		pr_err("Invalid data_pages_per_blk %d.\n", val);
+		return -EINVAL;
+	}
+
 	if (val > TCMU_MBS_TO_PAGES(udev->data_area_mb)) {
 		pr_err("Invalid data_pages_per_blk %d: greater than max_data_area_mb %d -> %zd pages).\n",
 		       val, udev->data_area_mb,
-- 
2.53.0



