Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2AC330B0C;
	Fri, 17 Oct 2025 15:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716081; cv=none; b=K7wmZO7k8pDdoaU7KuAVahHMnjSM+1vYf0YqyPP4OwvKWZ6SK76DKm2hMmdu8V4O5s3FVboG9zQtPy/Zas1EHdAp0YWgSqHad5qD72YdclxAtd8xmqtXbXSNF5IKzCC3uZgxewMmuJzv67NmUzNJ0BZ/+7NALrgyUhIkMHXz7S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716081; c=relaxed/simple;
	bh=0qDlesy/JIIobQyJ/+ziioU5vbgMRYLB1ip5flrO5kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mfDOMUNeoq7x2y9kbgEvRMcV7UeSwdmpLIcKUSY0nbynvOa/egzcRlVNUwromtR2NktNUWBJQdSLKzdzQrVNuEzLazNY9tbzjBdzJts3s9YD0pHtHCL5RYNYRnHZoUhzCBhJ8IwG4mFvIrokA3Wvnleg6U0fHjBpN48oMQ5fLfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGjHnGQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGjHnGQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BCEC4CEE7;
	Fri, 17 Oct 2025 15:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716081;
	bh=0qDlesy/JIIobQyJ/+ziioU5vbgMRYLB1ip5flrO5kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGjHnGQ6ePkXPztfoFXYcEb+OM5Xo/cIDp+1zW6RZNZYr3zsftf7E7OXe7eczZNrF
	 kM7XRSknx9QyZF/SkPLaRhdCyjQKvvhsq+1UBR0mswHZowX1WCcGxjKSD/bLuy4Pbu
	 Pt2Zuk2Z4+Bnqo2tLdi6PUwiS4qFP+vAx17iTMYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/276] pinctrl: renesas: Use int type to store negative error codes
Date: Fri, 17 Oct 2025 16:52:12 +0200
Message-ID: <20251017145143.832604758@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit 9f062fc5b0ff44550088912ab89f9da40226a826 ]

Change the 'ret' variable in sh_pfc_pinconf_group_set() from unsigned
int to int, as it needs to store either negative error codes or zero
returned by sh_pfc_pinconf_set().

No effect on runtime.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Fixes: d0593c363f04ccc4 ("pinctrl: sh-pfc: Propagate errors on group config")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250831084958.431913-4-rongqianfeng@vivo.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/renesas/pinctrl.c b/drivers/pinctrl/renesas/pinctrl.c
index f3eecb20c0869..37f8d51046b89 100644
--- a/drivers/pinctrl/renesas/pinctrl.c
+++ b/drivers/pinctrl/renesas/pinctrl.c
@@ -755,7 +755,8 @@ static int sh_pfc_pinconf_group_set(struct pinctrl_dev *pctldev, unsigned group,
 	struct sh_pfc_pinctrl *pmx = pinctrl_dev_get_drvdata(pctldev);
 	const unsigned int *pins;
 	unsigned int num_pins;
-	unsigned int i, ret;
+	unsigned int i;
+	int ret;
 
 	pins = pmx->pfc->info->groups[group].pins;
 	num_pins = pmx->pfc->info->groups[group].nr_pins;
-- 
2.51.0



