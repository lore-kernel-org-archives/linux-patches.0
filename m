Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C4E221F0F;
	Mon, 23 Jun 2025 21:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713307; cv=none; b=pPlFxU/g58Q4nN1LqizT0FlP8/JIplR3cylExEGO2yo7GkctAdzSkH15SynmkSrCV7jTL+x0IRHcLpfCz4QzYkwG0NrrqEs7lAlLsMrUKOgh55kWSaY7Y2a7BAL/towzZOJGTTwrPfoqb8kJd/Z+IM08RlTXtze9KL+lmZnENvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713307; c=relaxed/simple;
	bh=5xtLfCfHeUww6dHPNKavw6R6ovfa/vd2+fIFRXUy8Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=juwnmjOJG+8b1OwqpPlAefkJ6MNfzOCnyxP57BpicUJDfrqXSLcO9b0wvAwpZamfWCRcP6CuXASpJEAt9scg4urkH3KYwLVSYK6BE4wixz/59wGDGX7Y8KhRYqGe7w6m5znU/EQXJ0MDLbFZtfNLPYXP/SjRGWWUDvIkYTfmyGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JdmbfFZ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JdmbfFZ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B7AC4CEEA;
	Mon, 23 Jun 2025 21:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713307;
	bh=5xtLfCfHeUww6dHPNKavw6R6ovfa/vd2+fIFRXUy8Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JdmbfFZ4LTdk9IkqssUR1eJp7tAxXt0R4orwYSpWMuqoc7+JyZhGK7EF5cbdSgXNf
	 pevdUhM6hfXdTCMkgL33sZDaqgZ87ENj7I+umcJbjGWofV02w89k1c+smeQ4Wig7BO
	 0TH8XCQwUeKqpGOvs5MkcLbTkBNwZqHDVuK3geQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wan Junjie <junjie.wan@inceptio.ai>,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [PATCH 6.6 059/290] bus: fsl-mc: fix GET/SET_TAILDROP command ids
Date: Mon, 23 Jun 2025 15:05:20 +0200
Message-ID: <20250623130628.782144387@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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


