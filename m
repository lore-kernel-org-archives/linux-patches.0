Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D1C5102A;
	Mon, 11 Dec 2023 18:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x61fd/90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565D9C433C7;
	Mon, 11 Dec 2023 18:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320547;
	bh=PGQfDvnv1RsJwehNqBVWuKF1iMCl5JmSYVaTBqxi57w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x61fd/90g2EBVv3oh3vBYAnBsN7j331hzeY6bx+cutWLdP6NAjobqii/9qA6e6v+C
	 VrhqQZs6g88nFIZNg//ATBtgiPp2s7wH6hiF3p1qnumusk/IG0v8D0RBF8aNz8e4SL
	 5WDl98rHNMCFmumt4ZOpyUir1OJMvTobTruRlUFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malcolm Hart <malcolm@5harts.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 101/194] ASoC: amd: yc: Fix non-functional mic on ASUS E1504FA
Date: Mon, 11 Dec 2023 19:21:31 +0100
Message-ID: <20231211182040.947621238@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Malcolm Hart <malcolm@5harts.com>

commit b24e3590c94ab0aba6e455996b502a83baa5c31c upstream.

This patch adds ASUSTeK COMPUTER INC  "E1504FA" to the quirks file acp6x-mach.c
to enable microphone array on ASUS Vivobook GO 15.
I have this laptop and can confirm that the patch succeeds in enabling the
microphone array.

Signed-off-by: Malcolm Hart <malcolm@5harts.com>
Cc: stable@vger.kernel.org
Rule: add
Link: https://lore.kernel.org/stable/875y1nt1bx.fsf%405harts.com
Link: https://lore.kernel.org/r/871qcbszh0.fsf@5harts.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -286,6 +286,13 @@ static const struct dmi_system_id yc_acp
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "E1504FA"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "TIMI"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Redmi Book Pro 15 2022"),
 		}


