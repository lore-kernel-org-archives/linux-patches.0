Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9DB22257E;
	Tue,  8 Apr 2025 11:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113196; cv=none; b=m+63hDC3k+z2J49Iu2tfxR/E7+d+ozyxmrb/rxsDrlHj8GT5vNWKdwWhg2zH76TGdBzmu+hN2dCM/QY7cPW/Pk/Q2ltN0y38VQZ3gssClp+mkF0D+3wkMKdhPwyCVkdbFSzDWIxjWTY8+hlQ1mR+PgnIESCCkCrAwooqhMqGVKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113196; c=relaxed/simple;
	bh=BrFnvSWShk5M2wabR6vRqPlPE1Cj2sMEnq3AK7LNnZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=debTml0X7vxMpKvY30lzKAKVpui9dwpvR0XGGbVIgPanl+nTVvbZpAifyPiPuMNLSIL2gKZrVM/MuygLePDFqzZChftxfzzOnZieVfnjePiXHb3GD/Dnmz3FV+6G72U/6djG6YvZJLtDobotwkDcyvUfV9/k2a7xG5+VpDAj6LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XUQ5Zlzq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XUQ5Zlzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086F1C4CEE5;
	Tue,  8 Apr 2025 11:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113196;
	bh=BrFnvSWShk5M2wabR6vRqPlPE1Cj2sMEnq3AK7LNnZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XUQ5ZlzqnjxCJNaGxafrQw6ow5RLhdVYsWufYFyr2sedLDNiP1I0Xt7VE/0cjnMQV
	 eddgkmLFYTonlz9m243wtPBf+WSc0UKu4IUxPPjZNihohPISc/zTFZ6jC+U74N24TK
	 fVYDy3Ol/e+75r8xILR9zpeAGfos2NmOruyb+kEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Maud Spierings <maudspierings@gocontroll.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/268] dt-bindings: vendor-prefixes: add GOcontroll
Date: Tue,  8 Apr 2025 12:47:20 +0200
Message-ID: <20250408104829.290371145@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

From: Maud Spierings <maudspierings@gocontroll.com>

[ Upstream commit 5f0d2de417166698c8eba433b696037ce04730da ]

GOcontroll produces embedded linux systems and IO modules to use in
these systems, add its prefix.

Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Maud Spierings <maudspierings@gocontroll.com>
Link: https://patch.msgid.link/20250226-initial_display-v2-2-23fafa130817@gocontroll.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 12a16031d7b6d..dc275ab60e534 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -524,6 +524,8 @@ patternProperties:
     description: GlobalTop Technology, Inc.
   "^gmt,.*":
     description: Global Mixed-mode Technology, Inc.
+  "^gocontroll,.*":
+    description: GOcontroll Modular Embedded Electronics B.V.
   "^goldelico,.*":
     description: Golden Delicious Computers GmbH & Co. KG
   "^goodix,.*":
-- 
2.39.5



