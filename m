Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C0E1A01C6;
	Mon,  2 Jun 2025 14:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874112; cv=none; b=T5PQOBzHmuCQYM+86EvNde/FABBZASYapYkQgp7En+K+zU9xwwkg7Z9ZLhurNJ24pOluECyoNTF3k0Npik+8jG0KC8bPxYN0xL2KmY76zKPA8tDin8H/YJ3vXynCiQizvAvRI5rHoWEB2xivQnvpbzWdrRvpenehJUUaNLoq4EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874112; c=relaxed/simple;
	bh=vPfezUKTEFYhc1cQAyNjL3s8Sf35igCmhWoOSEj0lgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cM+Ezv0aQEcOHv9QDr8UoFSZpEJpAvtJLrXGEEClANoukSP8Lmlqn0skCuziWmz3KC/vaHy0iAu9ETaLIzH1Hwu2AvsoZTUSgAJbZj6FM34Tg7BhV5bLPsYO+ainPyXZtGM6bXXtUQ27SnT1fGgDN5ab86COnp1pHCvS62VCLhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iOPrAzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iOPrAzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FEF1C4CEEB;
	Mon,  2 Jun 2025 14:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874112;
	bh=vPfezUKTEFYhc1cQAyNjL3s8Sf35igCmhWoOSEj0lgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2iOPrAzvCCLYskqbmn4uO9m4rxiLVczJlfZxFRwetuOpE1IeR92fvPl2jIDAuHX5C
	 /sfIJ9bSl8N6yELk3L+UWkOSfLnJtKcfPe5KSVHplTmDSi8GpzuVAVGDNCCGaVv9pt
	 1cWlvmexYgAWQtaX9VqZbRfpB6GRYvghDuVTe3Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 361/444] ASoC: SOF: ipc4-control: Use SOF_CTRL_CMD_BINARY as numid for bytes_ext
Date: Mon,  2 Jun 2025 15:47:05 +0200
Message-ID: <20250602134355.572735939@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -483,6 +483,14 @@ static int sof_ipc4_bytes_ext_put(struct
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
@@ -565,7 +573,8 @@ static int _sof_ipc4_bytes_ext_get(struc
 	if (data_size > size)
 		return -ENOSPC;
 
-	header.numid = scontrol->comp_id;
+	/* Set header id and length */
+	header.numid = SOF_CTRL_CMD_BINARY;
 	header.length = data_size;
 
 	if (copy_to_user(tlvd, &header, sizeof(struct snd_ctl_tlv)))


