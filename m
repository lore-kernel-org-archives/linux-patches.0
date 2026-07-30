Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5FE382F01;
	Thu, 30 Jul 2026 15:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426534; cv=none; b=ret6hebFHw31swnsfWZpHhzBK/KgTmvbOaynh7EiwzVrsH4MPYmGc1iaXLWsUekFCeI1PJTpHj1dM/ILZsWPfJomXMq2q0EJdp8rILQ//iIHj0NxhCrffM+TqgqvCE/wC1yEuDhZbfJJ9vGEk0eVGcnTBMbv+qC6aRdQKmrBSTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426534; c=relaxed/simple;
	bh=AXpdiWcQ8u3DkztwXEsep2HC7/RMjiK7m665h0tGIIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUn/R+OglWt2H33EbpBGLh3TxcwOT3I3bfu0Qgn4nElv1fTqlrEAg3xgaWE7PoLkCyvAr0UDLUSws8o+R//0KhBOqTNmTvwfo84qZ+/1ExondvAn1JFkaZ5QvM2z2yo6BeZ96ovtn8kaJfn8i1K8ARXYU0w3sz8evwS3Mnr1zyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6eoWkVu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6eoWkVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A5A1F000E9;
	Thu, 30 Jul 2026 15:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426533;
	bh=Q/TfLOYlSzvaBLJOotn1XCZb7ZkyU/PSLaNLNAd7rus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6eoWkVu4INBGvyi1jDSZhbQnULY/GCnlaaiiWlBHbGvas2WgGJLcDj1gptA4nS97
	 qjsmvCSO+VFr+glYWbVVbStHmadouJXlaZMNWMWpFhNMROOECodoexep0i3bzjKppR
	 7sgGtw4msdvzYBBrjAQjHMf9JxijEbGzrAqY4p84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 452/602] net: qrtr: ns: Raise node count limit to 512
Date: Thu, 30 Jul 2026 16:14:04 +0200
Message-ID: <20260730141445.457546839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>

commit ff194cffd586cbd4cc49eccb002c65f2a902a277 upstream.

The current node limit of 64 breaks the functionality for a number of AI200
deployments that have up to 384 nodes. Raise the limit to 512.

Fixes: 27d5e84e810b ("net: qrtr: ns: Limit the total number of nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Link: https://patch.msgid.link/20260713145901.212396-1-youssef.abdulrahman@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/ns.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index a10e8de4f7e105..e8e3ba1b3b8239 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -85,9 +85,9 @@ struct qrtr_node {
 /* Max nodes limit is chosen based on the current platform requirements.
  * If the requirement changes in the future, this value can be increased.
  */
-#define QRTR_NS_MAX_NODES   64
+#define QRTR_NS_MAX_NODES   512
 
-static u8 node_count;
+static u16 node_count;
 
 static struct qrtr_node *node_get(unsigned int node_id)
 {
-- 
2.53.0



