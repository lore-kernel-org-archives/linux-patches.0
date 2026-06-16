Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCFF477994;
	Tue, 16 Jun 2026 16:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627572; cv=none; b=ZyhAbP5AUp50MPa4u7EFWsSuUHKkG9lI8U3Omxf+pJb88Cae9GgfZPEJlZi5oRTk9NbpDCxDE/2FRZ7e36TyR4YHFHmCm8MXE3KgFBefyGBsOchxtBrELxtKCgCRLZ9aOoZVKs0eHsp5DeyFhYwIxCUwukovpLZ+h3Y4Ozbszo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627572; c=relaxed/simple;
	bh=js95/L1PRUzd7Qk9VgZtAY9v1DzxeyZ0Bqn8gDdB9VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHnv/VpVfeZW6/P+zAbNZ6PeYplEg5hUsRI9tL8I4QYwLXzFUvICj6EewjxHiMuv5fMSJgyyXLLT6f9Ifu4XsBHmH3ek48o7guV1iS+ESbOjgIm0uqrGup5yOydVn5DNOaKpQkdq3NcyHTCZqbDssI3vnVxJkTELS+USrrK+/6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sy9u49fz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sy9u49fz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC5D1F000E9;
	Tue, 16 Jun 2026 16:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627570;
	bh=sPzk5KUu+KnTQqDxBvtSAIjN837FnV67xqNDf+dRu1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sy9u49fzRa3Ez2MHg99osn4+Rt4d7SGikk2+8zmVZun2ZaW5M962uRf7KUbX6FzMZ
	 THIzfMsmDCTmG4qhJ6dh6xHVUheCTnSCuWlEO2pulG7i9GBJQ4O2jdw4/prA9bSNJB
	 ++AuY+yfg5scvanS9sJiBGvyQ1jIgCQJHBzjK6sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfei Ren <lcrhf@outlook.com>,
	stable@kernel.org,
	Cryolitia PukNgae <cryolitia.pukngae@linux.dev>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 176/261] Input: atkbd - skip deactivate for HONOR BCC-Ns internal keyboard
Date: Tue, 16 Jun 2026 20:30:14 +0530
Message-ID: <20260616145053.237178247@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cryolitia PukNgae <cryolitia.pukngae@linux.dev>

commit fb402386af4cdce108ff991a796386de55439735 upstream.

After commit 9cf6e24c9fbf17e52de9fff07f12be7565ea6d61 ("Input: atkbd -
do not skip atkbd_deactivate() when skipping ATKBD_CMD_GETID"), HONOR
BCC-N, aka HONOR MagicBook 14 2026's internal keyboard stops
working. Adding the atkbd_deactivate_fixup quirk fixes it.

DMI: HONOR BCC-N/BCC-N-PCB, BIOS 1.04 04/07/2026

Fixes: 9cf6e24c9fbf17e52de9fff07f12be7565ea6d61 ("Input: atkbd - do not skip atkbd_deactivate() when skipping ATKBD_CMD_GETID")
Reported-by: Hongfei Ren <lcrhf@outlook.com>
Link: https://github.com/colorcube/Linux-on-Honor-Magicbook-14-Pro/issues/1#issuecomment-4562679891
Tested-by: Hongfei Ren <lcrhf@outlook.com>
Cc: stable@kernel.org
Signed-off-by: Cryolitia PukNgae <cryolitia.pukngae@linux.dev>
Link: https://patch.msgid.link/20260605-honor-v1-1-78e05e491193@linux.dev
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/atkbd.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1945,6 +1945,13 @@ static const struct dmi_system_id atkbd_
 		},
 		.callback = atkbd_deactivate_fixup,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HONOR"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "BCC-N"),
+		},
+		.callback = atkbd_deactivate_fixup,
+	},
 	{ }
 };
 


