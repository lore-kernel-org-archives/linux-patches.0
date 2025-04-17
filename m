Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB2E22566E2;
	Thu, 17 Apr 2025 17:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912651; cv=none; b=EueifKxNUBXRVbvojtD3WM/OHOx2akYdUA8UYXy7ibudexM59novSFjGFehPgVmWrFHr5khZ+8qVnMpelSgvLXyVqqSE3MxY4/D0jKj0zpj35LWOIk2wkZnj53g5zGM/FQ7YsY33PCV8BaCB53Sx9JyIpE6OvoaP6gAiBKQkWcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912651; c=relaxed/simple;
	bh=TUmObNI0NIm8jIAaGQpjbRBQQ+QRalioVyVagitt+74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eB9oijJRY2okGvWMkk84RVLG9wFpb8NUTdTemmRmbEQo0PljxyigdKLBBI58QexDgSLQ+aaWiZsqf/5jQIKRdI9pwNbAkzwZTAUEASS/qsaC8Mugau70oKYZFUvk1tf9PTlc5oaGIdcouVrHJWSvGsgm+jJMkY+z7devMLORzeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E81Y0T0C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E81Y0T0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756F8C4CEE4;
	Thu, 17 Apr 2025 17:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912650;
	bh=TUmObNI0NIm8jIAaGQpjbRBQQ+QRalioVyVagitt+74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E81Y0T0CTdkpKFANSEsX9t3Oo8Y8a09JROWYgPxKaFE2GhKuLzVYSbOBQgq3jSPNG
	 jV5ZyEFcmWj6H3h2hHb7bn7tpX7jJOUJNDKLc1yro2PltrBNZfbNybSEqnBypr+HYH
	 aaWeEioeKT0Dk+xsRYVT1pgWQ9a6rjXavMKfoHPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 080/449] ASoC: amd: ps: use macro for ACP6.3 pci revision id
Date: Thu, 17 Apr 2025 19:46:08 +0200
Message-ID: <20250417175121.191588182@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 4b36a47e2d989b98953dbfb1e97da0f0169f5086 ]

Use macro for ACP6.3 PCI revision id instead of hard coded value.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20250207062819.1527184-3-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/acp63.h  | 1 +
 sound/soc/amd/ps/pci-ps.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/amd/ps/acp63.h b/sound/soc/amd/ps/acp63.h
index e54eabaa4d3e1..28d3959a416b3 100644
--- a/sound/soc/amd/ps/acp63.h
+++ b/sound/soc/amd/ps/acp63.h
@@ -11,6 +11,7 @@
 #define ACP_DEVICE_ID 0x15E2
 #define ACP63_REG_START		0x1240000
 #define ACP63_REG_END		0x125C000
+#define ACP63_PCI_REV		0x63
 
 #define ACP_SOFT_RESET_SOFTRESET_AUDDONE_MASK	0x00010001
 #define ACP_PGFSM_CNTL_POWER_ON_MASK	1
diff --git a/sound/soc/amd/ps/pci-ps.c b/sound/soc/amd/ps/pci-ps.c
index 8b556950b855a..6015dd5270731 100644
--- a/sound/soc/amd/ps/pci-ps.c
+++ b/sound/soc/amd/ps/pci-ps.c
@@ -562,7 +562,7 @@ static int snd_acp63_probe(struct pci_dev *pci,
 
 	/* Pink Sardine device check */
 	switch (pci->revision) {
-	case 0x63:
+	case ACP63_PCI_REV:
 		break;
 	default:
 		dev_dbg(&pci->dev, "acp63 pci device not found\n");
-- 
2.39.5



