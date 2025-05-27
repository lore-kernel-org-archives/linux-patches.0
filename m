Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E675182D7;
	Tue, 27 May 2025 17:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366188; cv=none; b=SFSGVLqgwdPVXXfkZM+tL8rl9zo6WwigCbZBVlTeBi0myawxiykDPqocn8egOw7gEZeX0NSqxrWDFzjBARqkM4AgzqmCf4wh9gaAeJYBHWBzIVELimXO0uTR/kxuxFQgbcFgnnyjTZJFniPseh/LFSmLS3GPR7KsP+kS0Yb6qho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366188; c=relaxed/simple;
	bh=4UbnXvZ8IQCHGynFW6bE70DRttAtOdtIfomIAcLrxXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYaJPSYYgy7xYk9nzSSxbIzTUkuFEhRmsVnm4LRJXUOB1B7faG0b+P/fbuX2Ld3D/XlSJ19iz1unM2Sf2x4YGyTrdaP52b19tn9AkySaAAivzf99G3N0+IShHUfjC5IWhZ0pNqJn4mKsRXvNVgQj8mU7ScbeOVGE6uXDDzY36gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=weh0sbsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="weh0sbsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97B3C4CEE9;
	Tue, 27 May 2025 17:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366188;
	bh=4UbnXvZ8IQCHGynFW6bE70DRttAtOdtIfomIAcLrxXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=weh0sbsRo+KfuUE+m7Eac0fdealq+2kigLDQb3rS7hF/vyZ5GF+LD3pkq72XJPiUo
	 jaZoW0d0YeQnQOpbiU9L1VOUNKh52ZWPOwdON0MtdMHgrVJiSpvHgXDWbYNwerG3cM
	 C+gLBMF5gTp/XQ4rMeZQNjq0b1yn6PL1eJdIl7sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 575/626] ASoC: SOF: ipc4-control: Use SOF_CTRL_CMD_BINARY as numid for bytes_ext
Date: Tue, 27 May 2025 18:27:48 +0200
Message-ID: <20250527162508.337916429@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 4d14b1069e9e672dbe1adab52594076da6f4a62d upstream.

The header.numid is set to scontrol->comp_id in bytes_ext_get and it is
ignored during bytes_ext_put.
The use of comp_id is not quite great as it is kernel internal
identification number.

Set the header.numid to SOF_CTRL_CMD_BINARY during get and validate the
numid during put to provide consistent and compatible identification
number as IPC3.

For IPC4 existing tooling also ignored the numid but with the use of
SOF_CTRL_CMD_BINARY the different handling of the blobs can be dropped,
providing better user experience.

Reported-by: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
Closes: https://github.com/thesofproject/linux/issues/5282
Fixes: a062c8899fed ("ASoC: SOF: ipc4-control: Add support for bytes control get and put")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Link: https://patch.msgid.link/20250509085633.14930-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-control.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/sound/soc/sof/ipc4-control.c
+++ b/sound/soc/sof/ipc4-control.c
@@ -531,6 +531,14 @@ static int sof_ipc4_bytes_ext_put(struct
 		return -EINVAL;
 	}
 
+	/* Check header id */
+	if (header.numid != SOF_CTRL_CMD_BINARY) {
+		dev_err_ratelimited(scomp->dev,
+				    "Incorrect numid for bytes put %d\n",
+				    header.numid);
+		return -EINVAL;
+	}
+
 	/* Verify the ABI header first */
 	if (copy_from_user(&abi_hdr, tlvd->tlv, sizeof(abi_hdr)))
 		return -EFAULT;
@@ -613,7 +621,8 @@ static int _sof_ipc4_bytes_ext_get(struc
 	if (data_size > size)
 		return -ENOSPC;
 
-	header.numid = scontrol->comp_id;
+	/* Set header id and length */
+	header.numid = SOF_CTRL_CMD_BINARY;
 	header.length = data_size;
 
 	if (copy_to_user(tlvd, &header, sizeof(struct snd_ctl_tlv)))


