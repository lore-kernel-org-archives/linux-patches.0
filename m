Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCCA6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B000C433CB;
	Sun, 17 Sep 2023 20:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980967;
	bh=WnWQWnWF/TWLOGRpyJPW12sP9rL/effd7bhur1lbaCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PrQYnUzyHQW8gbSgLmpIk7Al9XLGktND7gAGO33uXlaAlizJHZM9GtDrNHsAEPdIa
	 pfNbvluKHTbEeZMzF4B766bukbgFnGznCqZ97XiQbyp9uYllHgpeXRgd9XBovFzAnt
	 rtDVyblAdUm21vDChh2OAY8qMIMFq2txG9p5qQk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Jassi Brar <jaswinder.singh@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/219] mailbox: qcom-ipcc: fix incorrect num_chans counting
Date: Sun, 17 Sep 2023 21:13:08 +0200
Message-ID: <20230917191043.213429803@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit a493208079e299aefdc15169dc80e3da3ebb718a ]

Breaking out early when a match is found leads to an incorrect num_chans
value when more than one ipcc mailbox channel is used by the same device.

Fixes: e9d50e4b4d04 ("mailbox: qcom-ipcc: Dynamic alloc for channel arrangement")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/qcom-ipcc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mailbox/qcom-ipcc.c b/drivers/mailbox/qcom-ipcc.c
index 7e27acf6c0cca..f597a1bd56847 100644
--- a/drivers/mailbox/qcom-ipcc.c
+++ b/drivers/mailbox/qcom-ipcc.c
@@ -227,10 +227,8 @@ static int qcom_ipcc_setup_mbox(struct qcom_ipcc *ipcc,
 			ret = of_parse_phandle_with_args(client_dn, "mboxes",
 						"#mbox-cells", j, &curr_ph);
 			of_node_put(curr_ph.np);
-			if (!ret && curr_ph.np == controller_dn) {
+			if (!ret && curr_ph.np == controller_dn)
 				ipcc->num_chans++;
-				break;
-			}
 		}
 	}
 
-- 
2.40.1



