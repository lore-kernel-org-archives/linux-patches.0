Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC11B8837;
	Mon, 28 Oct 2024 06:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098374; cv=none; b=oMr9Ewws5gIb268E4aYWknV91UpBoVWW17obMEAu0sFWbGYtFKEv6O6NIX3WJV4N8ExtY+RMwOxUuTvEEZbNOkLYK/fD0tcFxQlx4P2LkVG4O1MW+FsiYwjTUVxWQG4gaxGn6g1fy6hTRa4y+KGv6zVcay1MV2B+vATwQ3RAEDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098374; c=relaxed/simple;
	bh=6BkSAmCRbV6MHlvUhJ8468veXoYsv+acIoRNbGkHgSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=farIH8t2zPihFPgmnML6NHkQV023ZIswCZOXCjQMjccbBnCjT14RGcjoQnx12zG5hRKkUvbgSSB//PYj9uha6taI5LLAOX21jSIyNdEDnzeWw+Bir0he23I8rvLAR9Fn/Azu5S9Gu9zNCjA2vVPajoT1QTE7RM5nqeLHSfZ943A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tbncuI6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tbncuI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C00C4CEC3;
	Mon, 28 Oct 2024 06:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098374;
	bh=6BkSAmCRbV6MHlvUhJ8468veXoYsv+acIoRNbGkHgSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0tbncuI6FusRIQfTr4ML1rjIC36YzmWkdbECKLOWZUdZi2LdAr2CXJkgP4Cz2B/zZ
	 hjbn7bqX4l0UpFonA4vevBrFM1AwBjanbhZgrRJfntmeDzGhFIU58qlppkm/9Inhis
	 q3kBkFwJhHipCq+gUtmULDru89f0D9bAmjFUjMX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konradybcio@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 198/261] PCI/pwrctl: Add WCN6855 support
Date: Mon, 28 Oct 2024 07:25:40 +0100
Message-ID: <20241028062317.009756742@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konradybcio@kernel.org>

[ Upstream commit 0da59840f10141988e949d8519ed9182991caf17 ]

Add support for ATH11K inside the WCN6855 package to the power sequencing
PCI power control driver.

Link: https://lore.kernel.org/r/20240813191201.155123-1-brgl@bgdev.pl
[Bartosz: split Konrad's bigger patch, write the commit message]
Co-developed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Konrad Dybcio <konradybcio@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Konrad Dybcio <konradybcio@kernel.org>
Stable-dep-of: ad783b9f8e78 ("PCI/pwrctl: Abandon QCom WCN probe on pre-pwrseq device-trees")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pwrctl/pci-pwrctl-pwrseq.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pci/pwrctl/pci-pwrctl-pwrseq.c b/drivers/pci/pwrctl/pci-pwrctl-pwrseq.c
index f07758c9edadd..a23a4312574b9 100644
--- a/drivers/pci/pwrctl/pci-pwrctl-pwrseq.c
+++ b/drivers/pci/pwrctl/pci-pwrctl-pwrseq.c
@@ -66,6 +66,11 @@ static const struct of_device_id pci_pwrctl_pwrseq_of_match[] = {
 		.compatible = "pci17cb,1101",
 		.data = "wlan",
 	},
+	{
+		/* ATH11K in WCN6855 package. */
+		.compatible = "pci17cb,1103",
+		.data = "wlan",
+	},
 	{
 		/* ATH12K in WCN7850 package. */
 		.compatible = "pci17cb,1107",
-- 
2.43.0



