Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 934583F9F5E;
	Tue, 31 Mar 2026 16:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974490; cv=none; b=dUbdDYeV7b7JH6d6DF1z0asxlu7J/niG0wUILYkMemfl6r+pb33f4jXysSLaWIrVnTXMxalVf/4n/n7lt+8qx9kSzlDu6QgHKjsZhMr7A9AfBdyrWdrAjeO0XmF+I8lcqKkDH/MgbqnfML2/2f1WWYfoSeJ4vlsQC8LLpzsWDxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974490; c=relaxed/simple;
	bh=bxltIHO4PsHhVDu+u4HassSnBi4UUJxbVshu8Fg94sE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fXvSuP7gHCUnDXwZDMc+W676V+vGXwonwbNDokL/a5Y8sOGXN+zTNktiHwKp6f5GcncupezCTRvWwWI9NcXQp7LWF9/iGAEi703nVTmjfhPJ18DtB8i1/zAfbuqVNGL1VzAiY7ta1Fvo/TUSojb7NoFmOfIAsrk7a7853Ue+Erw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fa2GuXDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fa2GuXDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22272C19423;
	Tue, 31 Mar 2026 16:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974490;
	bh=bxltIHO4PsHhVDu+u4HassSnBi4UUJxbVshu8Fg94sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fa2GuXDp5aHdgXGMiE3W63T3nPCxz3a5eeSavxlRrdnKJPrRp6GGPrzNNno0wd9J7
	 fshuNiF90hV4S7rOeKE5xf7aXaPyNcfMjTRNRwbyKQWOkLtRc0fSvd2eoxUu7jYYj0
	 LSuFCs0vjHXo8dmVntVENl2CijhG/SM5ublUzGO0=
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
Subject: [PATCH 6.6 104/175] ASoC: SOF: ipc4-topology: Allow bytes controls without initial payload
Date: Tue, 31 Mar 2026 18:21:28 +0200
Message-ID: <20260331161733.602177836@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2203,7 +2203,7 @@ static int sof_ipc4_control_load_bytes(s
 		return -EINVAL;
 	}
 
-	if (scontrol->priv_size < sizeof(struct sof_abi_hdr)) {
+	if (scontrol->priv_size && scontrol->priv_size < sizeof(struct sof_abi_hdr)) {
 		dev_err(sdev->dev,
 			"bytes control %s initial data size %zu is insufficient.\n",
 			scontrol->name, scontrol->priv_size);


