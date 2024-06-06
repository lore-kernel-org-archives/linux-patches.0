Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5C71991DF;
	Thu,  6 Jun 2024 14:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682979; cv=none; b=uTq8naEkJURy/8o765axtu5LO5z+fOicyV5yZyO9XB52ZIYHJr2fB/Efvokd6zP9pBPk7YbsHIekqNGuFTwDNcGtw+eiKNUkh+p9dD1nhQycjgux6FGOJOMQyG7Oe5x9r4UwyoaEnNHMnmmfNPOBkpltWR1kLixDGgUsOtHmGlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682979; c=relaxed/simple;
	bh=QgXaQBGhMC75bIXVqaYYrJlTotnmzDKWS9t7KvFR8Mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ft1Mrjs8hvlDxAts9yqwxmDHXWvwIFkXqTaS65ywvqc5dlbyyQN7HjOTdw3rDaVWUZmboNQsFbG2uqqYYZXUTG7bucJyY6PhVMOqLHD6uX/0zNGq5Enlu3AAROypQG4AZLoiV/PVQPdntpkwJPStL0DgGsqkd6jggItkmnNzurw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBRt7gM2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBRt7gM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC9BC32781;
	Thu,  6 Jun 2024 14:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682979;
	bh=QgXaQBGhMC75bIXVqaYYrJlTotnmzDKWS9t7KvFR8Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBRt7gM2PzEfpIvHYg7B0WQPqMnTExLBo1mEfu7sBA2BBjgO0Hgk0mPHreRjwDRAZ
	 rjq1l8NLJCqlBsLZsxoCUYFtjjpkIJBePUhcbnDlM/QZi8Ikzwe13yZ7BtXWvd73Or
	 O84bkRsLXf8RaBA4+fXQYtolsXFl4FTZ0SbnarXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 160/374] media: ov2680: Allow probing if link-frequencies is absent
Date: Thu,  6 Jun 2024 16:02:19 +0200
Message-ID: <20240606131657.270023847@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit fd2e66abd729dae5809dbb41c6c52a6931cfa6bb ]

Since commit 63b0cd30b78e ("media: ov2680: Add bus-cfg / endpoint
property verification") the ov2680 no longer probes on a imx7s-warp7:

ov2680 1-0036: error -EINVAL: supported link freq 330000000 not found
ov2680 1-0036: probe with driver ov2680 failed with error -22

As the 'link-frequencies' property is not mandatory, allow the probe
to succeed by skipping the link-frequency verification when the
property is absent.

Cc: stable@vger.kernel.org
Fixes: 63b0cd30b78e ("media: ov2680: Add bus-cfg / endpoint property verification")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: 24034af644fc ("media: ov2680: Do not fail if data-lanes property is absent")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2680.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov2680.c b/drivers/media/i2c/ov2680.c
index 3e3b7c2b492cf..a857763c7984c 100644
--- a/drivers/media/i2c/ov2680.c
+++ b/drivers/media/i2c/ov2680.c
@@ -1123,18 +1123,23 @@ static int ov2680_parse_dt(struct ov2680_dev *sensor)
 		goto out_free_bus_cfg;
 	}
 
+	if (!bus_cfg.nr_of_link_frequencies) {
+		dev_warn(dev, "Consider passing 'link-frequencies' in DT\n");
+		goto skip_link_freq_validation;
+	}
+
 	for (i = 0; i < bus_cfg.nr_of_link_frequencies; i++)
 		if (bus_cfg.link_frequencies[i] == sensor->link_freq[0])
 			break;
 
-	if (bus_cfg.nr_of_link_frequencies == 0 ||
-	    bus_cfg.nr_of_link_frequencies == i) {
+	if (bus_cfg.nr_of_link_frequencies == i) {
 		ret = dev_err_probe(dev, -EINVAL,
 				    "supported link freq %lld not found\n",
 				    sensor->link_freq[0]);
 		goto out_free_bus_cfg;
 	}
 
+skip_link_freq_validation:
 	ret = 0;
 out_free_bus_cfg:
 	v4l2_fwnode_endpoint_free(&bus_cfg);
-- 
2.43.0



