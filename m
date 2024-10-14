Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE4A1AB525;
	Mon, 14 Oct 2024 14:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916887; cv=none; b=fYX8D9CoklaCRduJSShMLYXhnbl0JUw7n/7pQCyDVmPFjjkY7Z+e2XfoU5EgdRH4upRe1elUdlj1u2Voq2htE5f9IJHiGfn3y7lV0gw0W6fKP84romJn7BdFpdK+OfiAgh3fQmrG075iqhxAu5VVibQd46uisTupflv51Z42aMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916887; c=relaxed/simple;
	bh=WBD+6+IDh2PXIvwVfvE36cf7heCS7sii1mit73p0Nrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4qO7Kvm37eTZ4T89cZWvTIORMPfdrOqSS19h7kZzBU2ilc2RwkwIiPB3D8r10XtmIlHBcgoZp1pZmf7miwLRSSvta1gmQX3vGq88saukXaieymyFhfP34zRE7POhpbQMnh9qqNn0zeLYWFMo/Qfv0h88DjOy8Ra19xFgvtg9Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hchZghmi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hchZghmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69CBC4CEC3;
	Mon, 14 Oct 2024 14:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916887;
	bh=WBD+6+IDh2PXIvwVfvE36cf7heCS7sii1mit73p0Nrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hchZghmiMKK/sG/oDK9pm9SgB5s4oZ14uZZPkUw6375UbXnyOz0EiKiilWq88Pmqs
	 WFH4sXI6TNhXFYdG8HzQLZbtdtmsqqGmmehLyFS6uP90AXmVR1nI2xGHd78E7aolKR
	 DjnaVAuHpdduOFZEzW5pMIMiv1/aSs2aOCbqK+Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/213] comedi: ni_routing: tools: Check when the file could not be opened
Date: Mon, 14 Oct 2024 16:19:58 +0200
Message-ID: <20241014141046.561863794@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruffalo Lavoisier <ruffalolavoisier@gmail.com>

[ Upstream commit 5baeb157b341b1d26a5815aeaa4d3bb9e0444fda ]

- After fopen check NULL before using the file pointer use

Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
Link: https://lore.kernel.org/r/20240906203025.89588-1-RuffaloLavoisier@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c b/drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c
index d55521b5bdcb2..892a66b2cea66 100644
--- a/drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c
+++ b/drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c
@@ -140,6 +140,11 @@ int main(void)
 {
 	FILE *fp = fopen("ni_values.py", "w");
 
+	if (fp == NULL) {
+		fprintf(stderr, "Could not open file!");
+		return -1;
+	}
+
 	/* write route register values */
 	fprintf(fp, "ni_route_values = {\n");
 	for (int i = 0; ni_all_route_values[i]; ++i)
-- 
2.43.0



