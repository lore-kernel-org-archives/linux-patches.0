Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061373;
	b=0g4OyZFXfVV6PE41wRBXzSONj/XDOuyXWizHozoHpLs1/EM1/vYwaLgT1KnFpUj+aDIu
	 4DZjiWlgAXjQqOp037iisbbWQfDR2UMj2Odicy+DzqXuSaj2LCPAq9WnuYgrvVQqhnfjQ
	 3ZYuiQDIeS5w04S4fxWTmbD/rVV7dCqR5EEFbP3Lb6RMDAU5O7Y2yILfByHztcWcMbWEQ
	 y6wi2FXXKFksh/60NmZ9/Ro2/So8DhV0tv4DuxJECV2tQZthnR8fF2sXZ9btdjqzqLJ7b
	 HhC6Pvndx+P9r60NHYrQK60+u1p9elgJMdE0NvLA0T6x+mErUc2A0RQbHPq4HsjyQ9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7PavPYfSTggJK3ifWAC+RDOGOzZR3pHNZl9YrZuxCuA=;
	b=s+k4taJcQ4NNVxm3WsNBdqyTIaM0u1jQU2fHQx5qWAopwSGXhcyZ+2mvwFaJWsxgj5at
	 L4VZkQP24JLs9j3Q0J2+kW/7Jaqt5QgPCLHhYrA1noUWCu4SQBJt9dXBFZx9KKNgNwvZN
	 fnmVixgG97YkBPorUyZYH9bnrgzmm0Q4/g5VIDSiOkRRp3UquwfuoJ9Z0XEaCYizkYDYm
	 G3UScmURjmWxsyvbXNInquwA8PRTdziVCzGTto91IiTMMsv2m3+Q68ZWGJo5VHD45uWd9
	 5TvfMcmVx1eBQrMAN5Nym3ZwQHq1Q+QCTcEkFZ4woVpEm++b1l+wwP0BxlhHpz8ohQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Hdskd8p/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BF0606D80E;
	Sat,  7 Nov 2026 14:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hdskd8p/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF5C1F008A4;
	Sat,  7 Nov 2026 14:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061372;
	bh=7PavPYfSTggJK3ifWAC+RDOGOzZR3pHNZl9YrZuxCuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hdskd8p/042zlV64q2yGI4xA/z1X2eP3/Q8jcilU5rXfXHf+WC2g9UcmWXJAB+XXN
	 xOFFUUDA+u9UQSNkBYY+lQXHhF4e9tWY1/yQGeSCwhZFYL7xKH/EkiAb3gmL7wiAvq
	 4Mhi2CEUX+KaD2o9As6Nk+CrELmoRd1LCno/6nVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0458/1536] PCI/AER: Fix mapping of errors to agent & layer
Date: Sat,  7 Nov 2026 08:41:14 -0500
Message-ID: <20261107135010.391742972@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Added the six missing PCI_ERR_UNC_* bit 26–31 defines to pci_regs.h, since the new transmitter mask needs them and this tree lacks them. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c        | 24 +++++++++++++++++++-----
 include/uapi/linux/pci_regs.h |  6 ++++++
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 8df4eef7cd6ff..0e00ea3ae0b5a 100644
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
@@ -441,7 +453,8 @@ static const char * const aer_error_severity_string[] = {
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
index bf6c143551ec0..669503e245bfc 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -770,6 +770,12 @@
 #define  PCI_ERR_UNC_MCBTLP	0x00800000	/* MC blocked TLP */
 #define  PCI_ERR_UNC_ATOMEG	0x01000000	/* Atomic egress blocked */
 #define  PCI_ERR_UNC_TLPPRE	0x02000000	/* TLP prefix blocked */
+#define  PCI_ERR_UNC_POISON_BLK	0x04000000	/* Poisoned TLP Egress Blocked */
+#define  PCI_ERR_UNC_DMWR_BLK	0x08000000	/* DMWr Request Egress Blocked */
+#define  PCI_ERR_UNC_IDE_CHECK	0x10000000	/* IDE Check Failed */
+#define  PCI_ERR_UNC_MISR_IDE	0x20000000	/* Misrouted IDE TLP */
+#define  PCI_ERR_UNC_PCRC_CHECK	0x40000000	/* PCRC Check Failed */
+#define  PCI_ERR_UNC_XLAT_BLK	0x80000000	/* TLP Translation Egress Blocked */
 #define PCI_ERR_UNCOR_MASK	0x08	/* Uncorrectable Error Mask */
 	/* Same bits as above */
 #define PCI_ERR_UNCOR_SEVER	0x0c	/* Uncorrectable Error Severity */
-- 
2.53.0



