Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F5E222581;
	Mon, 23 Jun 2025 22:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716537; cv=none; b=ZhHWH65dizF3/hIxLS6yKY7m+r4doo627QYpORHKZmRybJKazK8X1eAqi4Qct/1an7av+0MAfuU1TnPzuoDKsoQfbiSC7lzQ8PD5UuHiPz/i7Uw9YnIfDVvfSwPZgb5mmHy0wiGtNZ7DHMi6h6rud2LvnM569ZVeT3tpwfzNwK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716537; c=relaxed/simple;
	bh=TY2nutP0LBRebRZFmNXScg9/9cpjyYDsMXhhGg4Cg74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/QFnzhWo+C32XbLDTZbL8splCFH7EenbYeRPSqtcFiLeCoo3xdrWrBINcuD1OKXl13Af+ZVj1lddvq9Uj/JC8klta0RdjgiEfNNAnf0o7gL5Rl+UAWR6LcqbzysSCg3LUORBslKJboa1FLEi0u/lPxLpi/peWR81DvCPcML8oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgpOBUyy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgpOBUyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC737C4CEEA;
	Mon, 23 Jun 2025 22:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716537;
	bh=TY2nutP0LBRebRZFmNXScg9/9cpjyYDsMXhhGg4Cg74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgpOBUyyqZXZoaLgBAcjfze9o6+dHo1RQo75TCgv2jCjuPXP7dl2a/KOFZXuRmSRc
	 TzfDmeznhJL9uCgNhblcUbs+1SLrLY0pvYOjb2smaRnloFZMdZkMAZ+z+YmYFXW/KF
	 v8/zYE96LF4led9vQvHsfPigV92Hz758hqNvQHXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wan Junjie <junjie.wan@inceptio.ai>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.1 333/508] bus: fsl-mc: fix GET/SET_TAILDROP command ids
Date: Mon, 23 Jun 2025 15:06:18 +0200
Message-ID: <20250623130653.524179744@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wan Junjie <junjie.wan@inceptio.ai>

commit c78230ad34f82c6c0e0e986865073aeeef1f5d30 upstream.

Command ids for taildrop get/set can not pass the check when they are
using from the restool user space utility. Correct them according to the
user manual.

Fixes: d67cc29e6d1f ("bus: fsl-mc: list more commands as accepted through the ioctl")
Signed-off-by: Wan Junjie <junjie.wan@inceptio.ai>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Cc: stable@vger.kernel.org
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20250408105814.2837951-4-ioana.ciornei@nxp.com
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/fsl-mc/fsl-mc-uapi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/bus/fsl-mc/fsl-mc-uapi.c
+++ b/drivers/bus/fsl-mc/fsl-mc-uapi.c
@@ -275,13 +275,13 @@ static struct fsl_mc_cmd_desc fsl_mc_acc
 		.size = 8,
 	},
 	[DPSW_GET_TAILDROP] = {
-		.cmdid_value = 0x0A80,
+		.cmdid_value = 0x0A90,
 		.cmdid_mask = 0xFFF0,
 		.token = true,
 		.size = 14,
 	},
 	[DPSW_SET_TAILDROP] = {
-		.cmdid_value = 0x0A90,
+		.cmdid_value = 0x0A80,
 		.cmdid_mask = 0xFFF0,
 		.token = true,
 		.size = 24,


