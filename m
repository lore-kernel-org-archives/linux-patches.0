Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6087E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94ECAC433D6;
	Wed,  2 Nov 2022 02:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356782;
	bh=vTkrxMsWLS2rRfBdrgJ0SlwPiJKsD7WhWaG+iFQD+as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlaCyKryuAg0Lw4DFCOgjQa411zAgXf9VQeasfLvkyBd3n9hZcmpSwB9zFVmv24v4
	 nF23xpsrLuutwR51r45PfogJCouxWtiMhOnK/f7FKGLWaMcYN0TXH3NrTmnclero2r
	 a3H0sSG/SaMfDYAGQ3OTTI9m4Ak89h3pIMOHI4FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jerome Audu <jerome.audu@st.com>,
	Felipe Balbi <felipe@balbi.sh>,
	Patrice Chotard <patrice.chotard@foss.st.com>
Subject: [PATCH 6.0 031/240] usb: dwc3: st: Rely on childs compatible instead of name
Date: Wed,  2 Nov 2022 03:30:06 +0100
Message-Id: <20221102022112.107984167@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Patrice Chotard <patrice.chotard@foss.st.com>

commit 3f53c329b31d53b2a2e7992819242fc0d4f883e0 upstream.

To ensure that child node is found, don't rely on child's node name
which can take different value, but on child's compatible name.

Fixes: f5c5936d6b4d ("usb: dwc3: st: Fix node's child name")
Cc: stable <stable@kernel.org>
Cc: Jerome Audu <jerome.audu@st.com>
Reported-by: Felipe Balbi <felipe@balbi.sh>
Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
Link: https://lore.kernel.org/r/20220930142018.890535-1-patrice.chotard@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-st.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-st.c
+++ b/drivers/usb/dwc3/dwc3-st.c
@@ -251,7 +251,7 @@ static int st_dwc3_probe(struct platform
 	/* Manage SoftReset */
 	reset_control_deassert(dwc3_data->rstc_rst);
 
-	child = of_get_child_by_name(node, "usb");
+	child = of_get_compatible_child(node, "snps,dwc3");
 	if (!child) {
 		dev_err(&pdev->dev, "failed to find dwc3 core node\n");
 		ret = -ENODEV;


