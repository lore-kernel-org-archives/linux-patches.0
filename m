Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4655612D7;
	Tue, 20 Feb 2024 21:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465196; cv=none; b=jRPMjA+V8xqffQcRnQkDrw6pbHEssMdw9BKJnJkYj9WdMo6Or56ZS7lo/czGAEr0/IjkNT4CM8o+oCocehfhwslYUCsc4wfWD++E+nZqanLx9EPBS5Ltl14xBdEZqEhzA7HZdw70ebRKJLeRux15hgPp5JWYDOUkwYpISDldsmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465196; c=relaxed/simple;
	bh=rXHvyvQ/m6wKW4kGtFUBK87t4JgdORD/AY9kCqRY3wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NNgcASIoE0ChVHq2j3vJBkA1285gFgzrKCnPQ99VhWCOiPaLB6r1C5GKIRznuLt1jKPgznR7HCMAwliK8Rb36d5DdWQ4oMQDaAM6q1ijOlf+CmhEzGrydFN9aKtXtgWZR4RP0aMgDMnWLyb1ynghuwtjkDVY4Nx45hrZrwyZwYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0G1C00YZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0G1C00YZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528CBC433F1;
	Tue, 20 Feb 2024 21:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465195;
	bh=rXHvyvQ/m6wKW4kGtFUBK87t4JgdORD/AY9kCqRY3wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0G1C00YZjMv4Uw9aGWgHqFOzJvRxajZMyfkBA5S37iopO+RbQTiZuY/+MsEXy0UA3
	 Q4oMG54abLCH4uBCMFZeHwEfSOjorFk1Li3bU0yrCS/VN8N5opByLTdPvml1BQ8VQs
	 u0Icfj7OR0U30gvfhscJKZ22gMb1oKoCUNqtJHW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Van Patten <timvp@google.com>,
	Curtis Malainey <cujomalainey@chromium.org>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.7 267/309] ASoC: SOF: IPC3: fix message bounds on ipc ops
Date: Tue, 20 Feb 2024 21:57:06 +0100
Message-ID: <20240220205641.502720104@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Curtis Malainey <cujomalainey@chromium.org>

commit fcbe4873089c84da641df75cda9cac2e9addbb4b upstream.

commit 74ad8ed65121 ("ASoC: SOF: ipc3: Implement rx_msg IPC ops")
introduced a new allocation before the upper bounds check in
do_rx_work. As a result A DSP can cause bad allocations if spewing
garbage.

Fixes: 74ad8ed65121 ("ASoC: SOF: ipc3: Implement rx_msg IPC ops")
Reported-by: Tim Van Patten <timvp@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Curtis Malainey <cujomalainey@chromium.org>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://msgid.link/r/20240213123834.4827-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/sof/ipc3.c
+++ b/sound/soc/sof/ipc3.c
@@ -1067,7 +1067,7 @@ static void sof_ipc3_rx_msg(struct snd_s
 		return;
 	}
 
-	if (hdr.size < sizeof(hdr)) {
+	if (hdr.size < sizeof(hdr) || hdr.size > SOF_IPC_MSG_MAX_SIZE) {
 		dev_err(sdev->dev, "The received message size is invalid\n");
 		return;
 	}


