Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A581CA8F;
	Mon,  1 Apr 2024 16:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987310; cv=none; b=YeZDS2+JomzISNHdw4fGOYByh2akmb6g+2C/y88JMRoHzwDPwKCsnSiUWsYFM/FlHnRTvbr6xOFebX80PU8CND9N8hl+6AF/7q+DECoGNR6SqzGgrXNx1l8ZhbXJWH/7GnwRj0g/UP/x5+598iZsafQreHUNlIA+Q+RHeWsM6H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987310; c=relaxed/simple;
	bh=ULQD9+D/G35WUrDgyhK+EULijTsmCmR1xfss97MnWn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNLXbFUDzR7HV+fOTaEXtaYF+IwARyMRQlqsDB/FWZuO2BMlLrKw4EXPYCrBxShfXd9VAvYeMWx0BXbMaDcb7CeAz45yaKHYxIQLC+3Be2v8DUyr3zyXPDLAlneUhSscBR1o3JvuW3bhhsO08blkmdvnWX6gYwWroPNwpok39XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2vYUQOOU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2vYUQOOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA4AC433F1;
	Mon,  1 Apr 2024 16:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987310;
	bh=ULQD9+D/G35WUrDgyhK+EULijTsmCmR1xfss97MnWn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2vYUQOOUeWeToTBR8j4jVtf4vRC+bclv6J4AoQr6ytd4R+9/o5ehcXvog/syldFZN
	 eSMEV7qEoWGPsAQhQbgg8yqaiCW+WDn2t9RF5beprEkDbjLKUt9ejFHY7xyOFyTkWo
	 q0FM/VOhT+DlcH9HgULejXo7TuhVERgXjv6G9FwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawei Wang <me@jwang.link>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.8 248/399] ASoC: amd: yc: Revert "add new YC platform variant (0x63) support"
Date: Mon,  1 Apr 2024 17:43:34 +0200
Message-ID: <20240401152556.573976129@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawei Wang <me@jwang.link>

commit 37bee1855d0e3b6dbeb8de71895f6f68cad137be upstream.

This reverts commit 316a784839b21b122e1761cdca54677bb19a47fa,
that enabled Yellow Carp (YC) driver for PCI revision id 0x63.

Mukunda Vijendar [1] points out that revision 0x63 is Pink
Sardine platform, not Yellow Carp. The YC driver should not
be enabled for this platform. This patch prevents the YC
driver from being incorrectly enabled.

Link: https://lore.kernel.org/linux-sound/023092e1-689c-4b00-b93f-4092c3724fb6@amd.com/ [1]

Signed-off-by: Jiawei Wang <me@jwang.link>
Link: https://msgid.link/r/20240313015853.3573242-3-me@jwang.link
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/pci-acp6x.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/soc/amd/yc/pci-acp6x.c
+++ b/sound/soc/amd/yc/pci-acp6x.c
@@ -162,7 +162,6 @@ static int snd_acp6x_probe(struct pci_de
 	/* Yellow Carp device check */
 	switch (pci->revision) {
 	case 0x60:
-	case 0x63:
 	case 0x6f:
 		break;
 	default:


