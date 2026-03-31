Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6860642317F;
	Tue, 31 Mar 2026 16:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975221; cv=none; b=Am3ox1WmSoBXvtEai93aZaJZrlmzTo/z9wxt0KiCEh6u2V8VmzKXOvGT3FJz8JRgcJTLdglibO8kPhQqFui5NZNjE031ibHKEp38YHhMVunyKSk3gFgofcnqYj5fswdfSnh0StQuUSpM6lsr7QtPOB/6UnqldzvNUwUyxs5jqwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975221; c=relaxed/simple;
	bh=wolcDTLeIQ1xypf5eQ79QjN3pysH4WCSwLJ6NfXxiuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVxPS8TU7Z23iZW4C+G03tmbZCF9DQbe+syigLLSahZJl45OphLjn82UfkZTxwGl1RyTLnFxUv9fBSXnKNnRmU6X07j++LwDqnGYyJm/eSadFvMdKWtgEI9wcxiMYx1bZiBSWyYuJWgc06FqNWXjVKzA3kcfbkM0V67ovbhF5sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=umH4cq0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="umH4cq0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9660C19423;
	Tue, 31 Mar 2026 16:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975221;
	bh=wolcDTLeIQ1xypf5eQ79QjN3pysH4WCSwLJ6NfXxiuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umH4cq0jMalHSii/M/BB+dl6YJDBA+xt31RpsJotcICk3kNlgPJ0fzo/mWOPF5O22
	 PlW27dAW/3c7cJnbEj1PU/sNYJ3rn+v+cmQEpfQVJBAv45WxmpVjIJuIbgE0IkbHr1
	 S0cAVRXEMHzGA0QJZHtEXKMe7vhIMwHZUZpt1zf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.19 211/342] ASoC: SOF: ipc4-topology: Allow bytes controls without initial payload
Date: Tue, 31 Mar 2026 18:20:44 +0200
Message-ID: <20260331161806.743576377@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit d40a198e2b7821197c5c77b89d0130cc90f400f5 upstream.

It is unexpected, but allowed to have no initial payload for a bytes
control and the code is prepared to handle this case, but the size check
missed this corner case.

Update the check for minimal size to allow the initial size to be 0.

Cc: stable@vger.kernel.org
Fixes: a653820700b8 ("ASoC: SOF: ipc4-topology: Correct the allocation size for bytes controls")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://patch.msgid.link/20260326075618.1603-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-topology.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -2889,7 +2889,7 @@ static int sof_ipc4_control_load_bytes(s
 		return -EINVAL;
 	}
 
-	if (scontrol->priv_size < sizeof(struct sof_abi_hdr)) {
+	if (scontrol->priv_size && scontrol->priv_size < sizeof(struct sof_abi_hdr)) {
 		dev_err(sdev->dev,
 			"bytes control %s initial data size %zu is insufficient.\n",
 			scontrol->name, scontrol->priv_size);


