Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831527;
	b=Xgo6WLGIpfq2uAqcRfS5yiOfkddTvKkenMn9QZi6A2EEAFMboDzb0Gd7ktwMFon4vV3a
	 lfsffwoDGrI6JHa7VK35LWMXIhqsI5JLKpCP/mdW9m7fOqb/4Qsm1U+l1kZJgwRSESyvj
	 MwRDYmp3tHafHCmfqalUcX+TacNYp/L/nP3Ucfpg9HIZjwqKH98N9ZSFh31wwj515/P3L
	 3jS7RQ44K4sDb6OTuFVI/XzBGJI75k+XvrIFwH+hldjYlDPztlDYsvfOYZ2NlIHP2uBfh
	 2yUXi7CfIUND8O+s/VtKYCyl06yMFAOOsUcvJrlc6m1TNv0L54HJ6i6HBlzt+h2csDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GrD6AD00gp/id+N7YYTlwvd5t0BF2+xZTqLnsfjMJfI=;
	b=r2UtD8YYN6+FKE+MkP/kvD1hF97/Xy2TXvd7GRD5dZsJNxZM28d1KYXBF3t9hccx10Fw
	 sUZ6B7kiYqkJFpsaWga4fnR0rkgsOEhG71mA1K7IFfAu1D41bWzPXdAfPpR+bLUpSK4EV
	 l0Y6fds9iI6sVMpfxRImcBtSNz+4P20FehAp1JdbblDu4VTREdOXM9etTwmA8M/U+LfSD
	 FmgvwQqCg1azpkTXbjgJEYa5aXXiNQfZGN1+YxBm/0AMo25rclc8WpCHU1f/wp/yy8JWS
	 o0HPGxE0dxig/nUCq0UBNXfRuH4CZosQmzTwu9xSWSy7K4LrLnVNKhqBFI68mCdaeog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTLwbNDh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B65606A841;
	Wed,  4 Nov 2026 22:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yTLwbNDh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1321F00919;
	Wed,  4 Nov 2026 22:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831526;
	bh=GrD6AD00gp/id+N7YYTlwvd5t0BF2+xZTqLnsfjMJfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yTLwbNDhtUeUirCh8zreubHyl8zpBM39Ll4GTEHqDdmKqg+bysJnd58qoV0HGgBx2
	 Jbh2PK4dpCIaP2qqiaVJvuecl1jacu5zW4xOuIbNOKu8OkCS/2T8VkJxzTy26KNHZ0
	 uORZD0A3NcJj9sq4sys+T7Jg0fAic/1HBToJcXCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.18 0719/1005] iommu/arm-smmu-v3: Disable the impl before disabling the SMMU on shutdown
Date: Wed,  4 Nov 2026 16:07:32 -0500
Message-ID: <20261104211103.667665602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

commit ab0dbf411aced59c04ce86fd8443faf13bdc9936 upstream.

arm_smmu_device_shutdown() only calls arm_smmu_device_disable(), and never
the impl_ops->device_disable() hook. On tegra241-cmdqv, that hook quiesces
every VINTF through tegra241_vintf_hw_deinit(), which issues a CMD_SYNC on
the shared CMDQ while it is still enabled.

arm_smmu_disable_action() already runs this hook before disabling the SMMU,
to cover an unbind or a probe failure, and no devres release ever follows a
reboot or a kexec to run it again. Have arm_smmu_device_shutdown() call it
directly, instead of reimplementing part of what it already does.

Fixes: 9ff145a25c5c ("iommu/tegra241-cmdqv: Fix CMD_SYNC use-after-free on teardown")
Cc: stable@vger.kernel.org
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Assisted-by: LLM
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4972,7 +4972,7 @@ static void arm_smmu_device_shutdown(str
 {
 	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
 
-	arm_smmu_device_disable(smmu);
+	arm_smmu_disable_action(smmu);
 }
 
 static const struct of_device_id arm_smmu_of_match[] = {


