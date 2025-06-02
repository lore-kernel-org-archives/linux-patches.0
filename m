Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8188B22F384;
	Mon,  2 Jun 2025 14:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874910; cv=none; b=KlBtooNQZTUZoxxwRiMRrCXeM7LCOAUs1T2SPsSc0ejHQLkF48h/vmjybEJ+hxoILq6Vfcr1KkCitFu7EKr89abrpiI2jKE1DQ1p9KW66OInYqeGCyJAkohdonAB82KaiOvA+3YY7NNsg01azmgLSVeHQ7NNbtMXinXd3nWuFs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874910; c=relaxed/simple;
	bh=zMh2v1Q+tM8dlcKaXzAMpIWLv2PltfJJl8lYzUyNQJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGZepuD/b7NHFOPbg5agG7cfFlPXWL6gkiLLlvJwadrQb6GYFf/W1VDOGBFEkimO6fOL+nzDJ3Qg8KJp5LKHtx2+9qXLYI+Nfw5n5LSoFW3pcpIoVcOVIzgdWhoDxP7ZY6kd6ZBxdJY5APWyNeQlIqsHRV4vp0SsmVmSHVD7PDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kz8dVtbn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kz8dVtbn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2816C4CEEB;
	Mon,  2 Jun 2025 14:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874910;
	bh=zMh2v1Q+tM8dlcKaXzAMpIWLv2PltfJJl8lYzUyNQJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kz8dVtbn8zsV+mVm6sPkRfG7sqpST7A5dTFvcEcrq3kInr8ZdfgQXICK00kU/bx5X
	 w/mfOxH6hfkTPjDdWAGoJmFRdaE+j99R3+eYh9SjZ5P5ftqy5QvaE7hRJSmFbVe3mD
	 THlgC0rrITwMdQQAutRHoKzLmqkGdX8N3tBoa2j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mateusz Polchlopek <mateusz.polchlopek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 142/204] net/mlx5: Modify LSB bitmask in temperature event to include only the first bit
Date: Mon,  2 Jun 2025 15:47:55 +0200
Message-ID: <20250602134301.226703830@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar Shitrit <shshitrit@nvidia.com>

[ Upstream commit 633f16d7e07c129a36b882c05379e01ce5bdb542 ]

In the sensor_count field of the MTEWE register, bits 1-62 are
supported only for unmanaged switches, not for NICs, and bit 63
is reserved for internal use.

To prevent confusing output that may include set bits that are
not relevant to NIC sensors, we update the bitmask to retain only
the first bit, which corresponds to the sensor ASIC.

Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Mateusz Polchlopek <mateusz.polchlopek@intel.com>
Link: https://patch.msgid.link/20250213094641.226501-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/events.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index 3ce17c3d7a001..9d7b0a4cc48a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -156,6 +156,10 @@ static int temp_warn(struct notifier_block *nb, unsigned long type, void *data)
 	u64 value_msb;
 
 	value_lsb = be64_to_cpu(eqe->data.temp_warning.sensor_warning_lsb);
+	/* bit 1-63 are not supported for NICs,
+	 * hence read only bit 0 (asic) from lsb.
+	 */
+	value_lsb &= 0x1;
 	value_msb = be64_to_cpu(eqe->data.temp_warning.sensor_warning_msb);
 
 	mlx5_core_warn(events->dev,
-- 
2.39.5



