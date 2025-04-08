Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E40E26E15A;
	Tue,  8 Apr 2025 12:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116182; cv=none; b=eru6NQZRdElndXNystU4bj5DiFtA8tgx73v6VxSSa/DqCeyN49TzkWvos+Ovb1j0kyWJLIXgilBHhn8DLXoKMX/9DVKQBBfzwYWJw9NuPbSREvrD14X2L9NjdQkfq/xmsuJAsB4jr+zCs2D73I1OrwsSlJzViPiKrNvOR9KrVuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116182; c=relaxed/simple;
	bh=GOBgzOv45ptNLDLgbKf1eWjGneoBRM/6PgvuF1BvunM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUpU7WumyLLZoqRseciqEgl4xiQzTXtslArOL9DJwZy2r9X3CUG/3P3jFELc/r4t/AVYbrmgljUBtPG/UniY69CaJEH0QOhpAQKnja0dEzXFCPNdztyceZ1afyU9No0CrWiZxmJBAbP+eTbgDAupQeW5E5W0kCjBJena5s20Rkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCe1r5dX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCe1r5dX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A4CC4CEE5;
	Tue,  8 Apr 2025 12:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116182;
	bh=GOBgzOv45ptNLDLgbKf1eWjGneoBRM/6PgvuF1BvunM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xCe1r5dXXxd6YUrfdIA9Hlkl04gk4GH0dLsSGt7XJ6u4jKuqzS9mgPWsdMPPDbfRW
	 otMU6Tgs8fenipKwSRNQ9dpY89efnNVDABIihJTSwTFMn2brQ6HrZ9BS1EU9lXOZ76
	 dOOxf5HaAhggTzRnQ7gTNU9FTedXSpVqKf6fohnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Maud Spierings <maudspierings@gocontroll.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 043/423] dt-bindings: vendor-prefixes: add GOcontroll
Date: Tue,  8 Apr 2025 12:46:09 +0200
Message-ID: <20250408104846.752910895@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index fbfce9b4ae6b8..71a1a399e1e1f 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -581,6 +581,8 @@ patternProperties:
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



