Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20AEB67E;
	Wed,  8 Apr 2026 18:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672739; cv=none; b=SaC6WosKXqsZ9q7jyVqiR6AolBGddRlv0tpENCdGfzWB2F7g4iHRI54FRGv7HuaqHxKDXgUii0F/NI0mYDsafudbSdVSZI36ZWxg8vh29rwKxvVZ+zD41SwgNS/NRuOgO+ATEZ2IidGIQQaCUCD1zEVg8sOu+iukbFiSm3oe1Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672739; c=relaxed/simple;
	bh=Opy3yPQ9r2oFlmtt+UGlV30GW1HCqPz3l0Qt4xx7QME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ti+xJcTeoCHZ6/nzgbqnH52pZSAYVGHMI+YZ2RRW/y7JgMhnNeUJX3BJ5Giw2jhNz49LgmYF5GvgBewVrwsjkBz5NiG9DTorBFSfzlYfYy3BCSXpEDuX7KwISU1RzthfTN0KIaFyl5j/TYIJNohzhZnaCqgnRF9MST0S6K/troY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urMKcpez; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urMKcpez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389A3C19421;
	Wed,  8 Apr 2026 18:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672739;
	bh=Opy3yPQ9r2oFlmtt+UGlV30GW1HCqPz3l0Qt4xx7QME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urMKcpezrr/0EKszLDDRPP18g1hJiyFpJTgegNTxDKvRJdZ+dyIWYjDkl5ZLBcYqI
	 JtRQvZ6RJZDiyRY9hDz8CWUjUJ2Cwb1atccPkNBW5e8RWwi+5g9HCQPelQGP4IAD/6
	 awtp3IKoHtXBSce3KY/wkU3olmE35vLCzEai6/4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Fabio Estevam <festevam@gmail.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.6 123/160] nvmem: imx: assign nvmem_cell_info::raw_len
Date: Wed,  8 Apr 2026 20:03:30 +0200
Message-ID: <20260408175917.783922360@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

From: Christian Eggers <ceggers@arri.de>

commit 48b5163c957548f5854f14c90bfdedc33afbea3c upstream.

Avoid getting error messages at startup like the following on i.MX6ULL:

nvmem imx-ocotp0: cell mac-addr raw len 6 unaligned to nvmem word size 4
nvmem imx-ocotp0: cell mac-addr raw len 6 unaligned to nvmem word size 4

This shouldn't cause any functional change as this alignment would
otherwise be done in nvmem_cell_info_to_nvmem_cell_entry_nodup().

Cc: stable@vger.kernel.org
Fixes: 13bcd440f2ff ("nvmem: core: verify cell's raw_len")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260327131645.3025781-2-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/imx-ocotp-ele.c |    1 +
 drivers/nvmem/imx-ocotp.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/nvmem/imx-ocotp-ele.c
+++ b/drivers/nvmem/imx-ocotp-ele.c
@@ -127,6 +127,7 @@ static int imx_ocotp_cell_pp(void *conte
 static void imx_ocotp_fixup_dt_cell_info(struct nvmem_device *nvmem,
 					 struct nvmem_cell_info *cell)
 {
+	cell->raw_len = round_up(cell->bytes, 4);
 	cell->read_post_process = imx_ocotp_cell_pp;
 }
 
--- a/drivers/nvmem/imx-ocotp.c
+++ b/drivers/nvmem/imx-ocotp.c
@@ -589,6 +589,7 @@ MODULE_DEVICE_TABLE(of, imx_ocotp_dt_ids
 static void imx_ocotp_fixup_dt_cell_info(struct nvmem_device *nvmem,
 					 struct nvmem_cell_info *cell)
 {
+	cell->raw_len = round_up(cell->bytes, 4);
 	cell->read_post_process = imx_ocotp_cell_pp;
 }
 


