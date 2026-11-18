Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043635;
	b=pXeORipYPnQtto+IMx1OFK2v0/bOA6hWXTewZ37k97TRRUrETehRPaH1N2RBQGZYldfF
	 wYXLPHDzaRNECVhdkbpuK4AvQiIKNzLCNidvNtZF98kEVv2CBW9r1fOhr6Pjp8hwO2Dlg
	 pA3xw/EVP6AlScPgc4RUzVk4slD90bCoOi9CPr7W38LecNFWbLbHpcJFTLI6RnAVxMCdi
	 NySuHSQEVESFjmcskTTxHYDZ+/GAfJiNar8eKGdmpSSpQDhmEr0n/6HPqUwTTkt/jVNFp
	 7fwQChJ3C0ecVk6mXSb9mrGwcQ0OJj4sjhNWofzrVwDOMCrrJfjmO5fw/RspWIeHi8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6rjTSrYN2iNgVnTZ1K/E7jploY5/SAtIayIQKFTy8ko=;
	b=wncEKqwyENiH9M2EIizO4pYaI493KQIOliwxa7t9Erl3+Ff+Ur0QxT9gnKHg+keSoztZ
	 7vXP7uFJOUzREjcqy1ksxm9i67YkMXP6iHtyoxxu5Mo8+zOGxqojkh9PIsBrVCPlTDYfy
	 rQwj8cLKJ5MlBf/I4sP2FLpuYOufj9K2Sp5e59odqYtBQFNeZsDFdJF16wrPuniXSUFx4
	 M49MnsFSVsMAemusN3zjqQND8JgylzRtD5C2A+M7buOJCskV8G8vn/RL4NJtd9fzI9FoG
	 aT1r1zTUNWQmdPqmUrJBZEXd56RIjuyVpVfz3WsO38aFg9xlcpbKPQl6RWrrtL1TMVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Trsz5Fms;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA8D60A2602;
	Wed, 18 Nov 2026 23:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Trsz5Fms
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8FE1F000CD;
	Wed, 18 Nov 2026 23:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043634;
	bh=6rjTSrYN2iNgVnTZ1K/E7jploY5/SAtIayIQKFTy8ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Trsz5Fmsy9Or+iXb/hl1lb860r0rdEAXDbezZ3/NCYsjdujXcu57G1ooZW7/3Ssyw
	 eoLWbW4Rw4TqYfe2uhwYrWvmGvLzgpvC500eBbJ+wPjm6JsR1R/WDCPFLJFRiVTr9F
	 j1L4VvsxTt7dgCkfJGHGwLaq2u76HJtOjY7V1IvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+10cd2d1efe8eeb604bee@syzkaller.appspotmail.com,
	syzbot+5ebe7cd17e48b4293660@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0239/2857] ALSA: hda/intel: Add sanity check for BAR0 size
Date: Wed, 18 Nov 2026 15:21:13 +0100
Message-ID: <20261118150210.057237033@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9895573b0185f922be4cf500a0f2e5b9560ab1c3 ]

The recent reports from syzkaller showed that we can bind any wild PCI
device to HD-audio controller, and if PCI BAR of the device is too
small, it may lead to a crash, as the driver believes as if the full
register range were accessible.

For avoiding such a problem, add a safeguard before the actual probe
to check the available BAR0 size.

Note that the threshold (0x200) is chosen to cover all needed
registers at probing.  But this doesn't mean that it would cover fully
for all features including the extended ones.

Reported-by: syzbot+10cd2d1efe8eeb604bee@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=10cd2d1efe8eeb604bee
Reported-by: syzbot+5ebe7cd17e48b4293660@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5ebe7cd17e48b4293660
Link: https://patch.msgid.link/20260813150354.763502-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 1bb315c175f67..38d7ca14a795b 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2159,6 +2159,15 @@ static int azx_probe(struct pci_dev *pci,
 		dev_warn(&pci->dev, "dmic_detect option is deprecated, pass snd-intel-dspcfg.dsp_driver=1 option instead\n");
 	}
 
+	/* A sanity check against wild device binding;
+	 * here the range 0x200 is enough for the registers used at probe,
+	 * but it doesn't mean covering all HD-audio registers
+	 */
+	if (pci_resource_len(pci, 0) < 0x200) {
+		dev_err(&pci->dev, "Too small PCI BAR0\n");
+		return -EINVAL;
+	}
+
 	err = snd_card_new(&pci->dev, index[dev], id[dev], THIS_MODULE,
 			   0, &card);
 	if (err < 0) {
-- 
2.53.0



