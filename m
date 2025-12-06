Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF6F19F40B;
	Sat,  6 Dec 2025 14:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765029809; cv=none; b=ZrTDcJsXdAK3WP8kxvGPruBwNuE+bvuWK3JxcbjI3H+oNGyX8B3liyYbHRHbxsG8ASn1N1W5C8DZCTqoztmpJ/Cfm5RR7Yt+Zn4ZnoEZF4wU+l2jcw7Mo+uf3F2f5fJai11QRcROvRkqQ8QQ9kyUShgWuJMZJPzIjxurINX5uBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765029809; c=relaxed/simple;
	bh=EgGF2tB/De5Vk9uNRu5+h2BmsafArVHztDGZSEiK8lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/0NyfboV+XyY3JA3yJRsuuxSnb83ITy+e/lPaLxFBx8jy/6D0rszgoqxfcb4SK/ZZVXKJgSiHUu+kPCrai9Y+0phnM3qvo2Ju1ZWIH7ex3rcnq/xCYqYM8op4EpneIGAg691xfKRQ5RbDFGJ+tuTIhMizgvUCyc7x30BIxdfyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rT68/hni; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rT68/hni"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3DEC4CEF5;
	Sat,  6 Dec 2025 14:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765029808;
	bh=EgGF2tB/De5Vk9uNRu5+h2BmsafArVHztDGZSEiK8lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rT68/hniMHztQ8J1Vg6uexW8t/bmJiN2lAu3FQRxRdl/AZHBkrUOC42tWtDoBAcJE
	 FOBrpRyOwFdsPrUrJvjSIP6qZhlTkxxHqKP4Swb+l80FkuF+0I9p2YcXkPywz+1hOR
	 Wi7cybBMJYIlNJp91HrZs51pVZOrU5jT6s11vRh4M+BzdnyeSUkc4k0XUc5cVh6S2i
	 YXxrqhZHgy8+47di0BWy5svcb0a91jmCrvBjhXzlMXkxb7+jUfEoBmIyQFzblIS8FR
	 FhhsbOFx5O77uIAhNZE9URFXkgBaimzJvy0HT/4MfmyuzKGTBvCDYiGzfg1ZFHFM0b
	 Ar526jo2NNo7Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shuai Zhang <quic_shuaz@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.17] Bluetooth: btusb: add new custom firmwares
Date: Sat,  6 Dec 2025 09:02:21 -0500
Message-ID: <20251206140252.645973-16-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251206140252.645973-1-sashal@kernel.org>
References: <20251206140252.645973-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: Shuai Zhang <quic_shuaz@quicinc.com>

[ Upstream commit a8b38d19857d42a1f2e90c9d9b0f74de2500acd7 ]

The new platform uses the QCA2066 chip along with a new board ID, which
requires a dedicated firmware file to ensure proper initialization.
Without this entry, the driver cannot locate and load the correct
firmware, resulting in Bluetooth bring-up failure.

This patch adds a new entry to the firmware table for QCA2066 so that
the driver can correctly identify the board ID and load the appropriate
firmware from 'qca/QCA2066/' in the linux-firmware repository.

Signed-off-by: Shuai Zhang <quic_shuaz@quicinc.com>
Acked-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:



 drivers/bluetooth/btusb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index cc03c8c38b16f..22f1932fe9126 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3267,6 +3267,7 @@ static const struct qca_device_info qca_devices_table[] = {
 
 static const struct qca_custom_firmware qca_custom_btfws[] = {
 	{ 0x00130201, 0x030A, "QCA2066" },
+	{ 0x00130201, 0x030B, "QCA2066" },
 	{ },
 };
 
-- 
2.51.0

