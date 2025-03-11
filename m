Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B978725DD02;
	Tue, 11 Mar 2025 15:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705602; cv=none; b=OlkbQzLwAvVW7ldH+IG2BgiRJ4+CZxQh8W/uFlYLigoPmmRaLjSt0f+aF7UwQnE2jgM/Pp4oS7J+VDRRdt+qmSe4aQdeViDHXrAUYDpZJifMx1LiqYki537X9fX7t/FhSCvIJ+nbjSDuvnOso3zA4AvqcNFj90xS34wP6KzsAE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705602; c=relaxed/simple;
	bh=yz22dO4qP4GVEUcgOOr8L32/Kb2jcjMFV/j0/sHvtzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzZDk/8simUbO5tHML3UdqPlDF/8s7LCoBVJVaG5RGCfldPqdIlnwcvsca76719YI0c60Xzc0R3Hz+FV+9JicqjqCHuzsBIdemJgxIB5zmQHU1dJlj85B8KNEd2FxKoXjLZ8Z1XbS8eYsKTJ8O8qQDia4yvQKa/QmWaWoN9W+cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FA38EV3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FA38EV3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135C6C4CEE9;
	Tue, 11 Mar 2025 15:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705602;
	bh=yz22dO4qP4GVEUcgOOr8L32/Kb2jcjMFV/j0/sHvtzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FA38EV3vGQdqlYhsqceyrhaFO9bQmsSKUM1bcB8hlyCgDBduhwQP0HM0KPKK0miSQ
	 OlP7KtIxZmNq3Ce7sli4EJOHEV1iWmLP8ua6M/W7QXxMbBpfwPqflzMT3Ap/i4340t
	 LmLQtvG4leUA+R5Y+stB0kE69tNnOKCjkEvdsOIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andy@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 092/328] mfd: lpc_ich: Add another Gemini Lake ISA bridge PCI device-id
Date: Tue, 11 Mar 2025 15:57:42 +0100
Message-ID: <20250311145718.547303391@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 1e89d21f8189d286f80b900e1b7cf57cb1f3037e ]

On N4100 / N4120 Gemini Lake SoCs the ISA bridge PCI device-id is 31e8
rather the 3197 found on e.g. the N4000 / N4020.

While at fix the existing GLK PCI-id table entry breaking the table
being sorted by device-id.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20241114193808.110132-1-hdegoede@redhat.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/lpc_ich.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index 3bbb29a7e7a57..d5a3c1923c0af 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -685,8 +685,9 @@ static const struct pci_device_id lpc_ich_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x2917), LPC_ICH9ME},
 	{ PCI_VDEVICE(INTEL, 0x2918), LPC_ICH9},
 	{ PCI_VDEVICE(INTEL, 0x2919), LPC_ICH9M},
-	{ PCI_VDEVICE(INTEL, 0x3197), LPC_GLK},
 	{ PCI_VDEVICE(INTEL, 0x2b9c), LPC_COUGARMOUNTAIN},
+	{ PCI_VDEVICE(INTEL, 0x3197), LPC_GLK},
+	{ PCI_VDEVICE(INTEL, 0x31e8), LPC_GLK},
 	{ PCI_VDEVICE(INTEL, 0x3a14), LPC_ICH10DO},
 	{ PCI_VDEVICE(INTEL, 0x3a16), LPC_ICH10R},
 	{ PCI_VDEVICE(INTEL, 0x3a18), LPC_ICH10},
-- 
2.39.5



