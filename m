Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034609;
	b=cahSDUBcNMTJcY5vsRlXHYnLJPP1YJiDzJGbboUSwpBWWRkj2ipAlcgDR5bOP8apJO41
	 NYr9lxbWCJjmlIjOWiAHW85sgq/Ij6MIYQD8APzjncpP6yaTdeRhjzZs+UaG5ught9lOY
	 E5CZds+kJY2fb3L1D0Q3/UBhLXcG9sAy59D+fb3+HvCENXisrw1EMOVQZOq3UaxnrdRxb
	 hYxFHrCAhyM2nOJLu21uRBtbr2bBSXtT/vZl/lF6pCZAyzjSc/Jo98kcHB+390Ph0TnCr
	 4831TbEfRScfdmsmEyTeHRjTE+ul9qxf8SB/yAMMqyaygqLVz/oatX3UqZebcpyog6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gRDsE+/cGUf2jwVhnnljL3i4qZUElNsmmQd+q5rr+T4=;
	b=eJNNKusnBL6YR7fhCH9xzZCZV+DXnuW/3ZomZ7NxSEJOlh0is5wk1z7Hwjh7AaRasZ6G
	 mbnHzvqi6W+kZKiDvPxs/pu2aYJ3+0kXV8FY5B5yqQ8SsSG0Gb5KLNibg6sXHVldaQjKO
	 KDMvA9fWDXZ2pFFmwYk2TuXcQzjueiKKhW7bcgBgzFSJkRtYICsRyQ1bUgMJFGN5ARMJK
	 y7wWwShyGNeVhRP/K5bK9jlSyyqcQMDWPJ77buP91GwKEWfl+pNMDqI/ILGE2uxfKLXQI
	 n+Omkzc0g2yzEV8o525vwhvl5s33wx6jtt53nqkAomkrNIOFJdPp5PMOx7FroQeapng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GHR+13lN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BA160A5BCD;
	Wed, 18 Nov 2026 20:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GHR+13lN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BD11F000CA;
	Wed, 18 Nov 2026 20:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034609;
	bh=gRDsE+/cGUf2jwVhnnljL3i4qZUElNsmmQd+q5rr+T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHR+13lN4M6Knd1iYjCMb5ZpoveiR9FWPSQyKaa/olchexaNdiAwd3tvUfMSHu8sU
	 oS6/uEDOplgtzsxoHgyFRSB8jTLfE1RT/YCx1v/TEy3iU5G7xpMpbFMt0VYuf4hQll
	 qaJzBMQUt2oEumR0B0l0OUJgQ3KZNx0nEXlL8euY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0383/3318] PCI/AER: Fix mapping of errors to agent & layer
Date: Wed, 18 Nov 2026 15:16:45 +0100
Message-ID: <20261118150327.766021171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 1017599755b8b578a671f8fac175bce56189d01c ]

PCIe r7.0 sec 6.2.7 documents the agent and layer of each Correctable and
Uncorrectable Error.  Based on this spec section, the AER driver maps
detected errors to an agent and layer using a set of macros and logs them.

Most errors listed in sec 6.2.7 map to the "Receiver" agent and
"Transaction Layer", so the macros use these as defaults unless an error
maps to something else.

However the macros have not been amended since their introduction in 2006
with commit 6c2b374d7485 ("PCI-Express AER implemetation: AER core and
aerdriver").  They are still based on PCIe r1.0 sec 7.2.5 (renumbered to
6.2.7 in PCIe r1.1 and newer).

Amend the macros to map errors introduced since then to the appropriate
agent and layer.

PCIe r2.1 introduced a new "Component" agent and "General" layer for
Internal Errors and Header Log Overflow.  Add them to the macros.

Unsupported Request is currently mapped to the "Requester" agent, even
though it is reported by the "Receiver".  Fix the incorrect mapping.

Sec 6.2.7 neglects to list an agent for Data Link Protocol Error and
Surprise Down Error.  Map the latter to "Component" because PCIe r7.0 sec
3.2.1 states that the error is "associated with the detecting Port".  Map
the former to "Receiver" because every occurrence of Data Link Protocol
Error in the spec refers to it being logged in the Receiving Port.  I have
had these errata reported to the PCI-SIG Protocol Working Group.  (There's
also a layout erratum in the REPLAY_NUM Rollover row wherein columns are
shifted to the left, but that's already corrected in the PCIe r7.1 draft
as of 2026-04-07.)

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/aec4820a75e949b332585a08cb1808fda7f40ea4.1784905909.git.lukas@wunner.de
[ sashal: Added three missing PCI_ERR_UNC_POISON_BLK, DMWR_BLK and XLAT_BLK bit definitions to pci_regs.h so the Transmitter mask compiles; aer.c otherwise matches upstream. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c        | 24 +++++++++++++++++++-----
 include/uapi/linux/pci_regs.h |  3 +++
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 608908552daf3..f40a6f4c79a58 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -398,23 +398,32 @@ void pci_aer_exit(struct pci_dev *dev)
 #define AER_AGENT_REQUESTER		1
 #define AER_AGENT_COMPLETER		2
 #define AER_AGENT_TRANSMITTER		3
+#define AER_AGENT_COMPONENT		4
 
 #define AER_AGENT_REQUESTER_MASK(t)	((t == AER_CORRECTABLE) ?	\
-	0 : (PCI_ERR_UNC_COMP_TIME|PCI_ERR_UNC_UNSUP))
+	0 : PCI_ERR_UNC_COMP_TIME)
 #define AER_AGENT_COMPLETER_MASK(t)	((t == AER_CORRECTABLE) ?	\
 	0 : PCI_ERR_UNC_COMP_ABORT)
 #define AER_AGENT_TRANSMITTER_MASK(t)	((t == AER_CORRECTABLE) ?	\
-	(PCI_ERR_COR_REP_ROLL|PCI_ERR_COR_REP_TIMER) : 0)
+	(PCI_ERR_COR_REP_ROLL|PCI_ERR_COR_REP_TIMER) :			\
+	(PCI_ERR_UNC_POISON_BLK|PCI_ERR_UNC_ATOMEG|			\
+	 PCI_ERR_UNC_DMWR_BLK|PCI_ERR_UNC_XLAT_BLK|			\
+	 PCI_ERR_UNC_TLPPRE))
+#define AER_AGENT_COMPONENT_MASK(t)	((t == AER_CORRECTABLE) ?	\
+	(PCI_ERR_COR_INTERNAL|PCI_ERR_COR_LOG_OVER) :			\
+	(PCI_ERR_UNC_INTN|PCI_ERR_UNC_SURPDN))
 
 #define AER_GET_AGENT(t, e)						\
 	((e & AER_AGENT_COMPLETER_MASK(t)) ? AER_AGENT_COMPLETER :	\
 	(e & AER_AGENT_REQUESTER_MASK(t)) ? AER_AGENT_REQUESTER :	\
 	(e & AER_AGENT_TRANSMITTER_MASK(t)) ? AER_AGENT_TRANSMITTER :	\
+	(e & AER_AGENT_COMPONENT_MASK(t)) ? AER_AGENT_COMPONENT :	\
 	AER_AGENT_RECEIVER)
 
 #define AER_PHYSICAL_LAYER_ERROR	0
 #define AER_DATA_LINK_LAYER_ERROR	1
 #define AER_TRANSACTION_LAYER_ERROR	2
+#define AER_GENERAL_ERROR		3
 
 #define AER_PHYSICAL_LAYER_ERROR_MASK(t) ((t == AER_CORRECTABLE) ?	\
 	PCI_ERR_COR_RCVR : 0)
@@ -422,11 +431,14 @@ void pci_aer_exit(struct pci_dev *dev)
 	(PCI_ERR_COR_BAD_TLP|						\
 	PCI_ERR_COR_BAD_DLLP|						\
 	PCI_ERR_COR_REP_ROLL|						\
-	PCI_ERR_COR_REP_TIMER) : PCI_ERR_UNC_DLP)
+	PCI_ERR_COR_REP_TIMER) : (PCI_ERR_UNC_DLP|PCI_ERR_UNC_SURPDN))
+#define AER_GENERAL_ERROR_MASK(t)  ((t == AER_CORRECTABLE) ?		\
+	(PCI_ERR_COR_INTERNAL|PCI_ERR_COR_LOG_OVER) : PCI_ERR_UNC_INTN)
 
 #define AER_GET_LAYER_ERROR(t, e)					\
 	((e & AER_PHYSICAL_LAYER_ERROR_MASK(t)) ? AER_PHYSICAL_LAYER_ERROR : \
 	(e & AER_DATA_LINK_LAYER_ERROR_MASK(t)) ? AER_DATA_LINK_LAYER_ERROR : \
+	(e & AER_GENERAL_ERROR_MASK(t)) ? AER_GENERAL_ERROR :		\
 	AER_TRANSACTION_LAYER_ERROR)
 
 /*
@@ -441,7 +453,8 @@ static const char *aer_error_severity_string[] = {
 static const char *aer_error_layer[] = {
 	"Physical Layer",
 	"Data Link Layer",
-	"Transaction Layer"
+	"Transaction Layer",
+	"General",
 };
 
 static const char *aer_correctable_error_string[] = {
@@ -518,7 +531,8 @@ static const char *aer_agent_string[] = {
 	"Receiver ID",
 	"Requester ID",
 	"Completer ID",
-	"Transmitter ID"
+	"Transmitter ID",
+	"Component ID",
 };
 
 #define aer_stats_dev_attr(name, stats_array, strings_array,		\
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 036991bee1a74..4d729128225b6 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -764,6 +764,9 @@
 #define  PCI_ERR_UNC_MCBTLP	0x00800000	/* MC blocked TLP */
 #define  PCI_ERR_UNC_ATOMEG	0x01000000	/* Atomic egress blocked */
 #define  PCI_ERR_UNC_TLPPRE	0x02000000	/* TLP prefix blocked */
+#define  PCI_ERR_UNC_POISON_BLK	0x04000000	/* Poisoned TLP Egress Blocked */
+#define  PCI_ERR_UNC_DMWR_BLK	0x08000000	/* DMWr Request Egress Blocked */
+#define  PCI_ERR_UNC_XLAT_BLK	0x80000000	/* Translation Egress Blocked */
 #define PCI_ERR_UNCOR_MASK	0x08	/* Uncorrectable Error Mask */
 	/* Same bits as above */
 #define PCI_ERR_UNCOR_SEVER	0x0c	/* Uncorrectable Error Severity */
-- 
2.53.0



