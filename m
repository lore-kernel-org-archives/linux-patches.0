Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F672135CD;
	Tue,  8 Apr 2025 11:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110456; cv=none; b=pmab+ntyIslKt+ltWNtD5vCuWvdJNmOXZ1kqqQ1qUf1NDrrxOOWb/Mhb3ojwOwIAg5bcIGwtJm96rpFa1H8oySjN2CC4/3sKW8Cwka2Ev/ppebGOnJl2hHBCf7uwjCxyPPmg4I+13/aVJoBNaEhEeYuqwUJc4CCKOpG6enhKzR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110456; c=relaxed/simple;
	bh=2z4IIA0dd3s1LhqIAzYeC5YsM6CQ5BkPuoMqRpzA/WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2GuGJ+rDb4pf0iGTCGZ5eJj69Ur1kPtxyBgaSAIxJ38W8HwKdELqvXOuMo5/it4jK7AQ3GMiOuvePqPg2VvrkqItP5n92QjjNqGy3iZJWD+gCU02NtC5jzpWpyg9w3jwUeS/D1NxTS3ZOS6KKxnClxS56b4p/PHOTf60l21Rro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DnHy2+eU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DnHy2+eU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4092FC4CEE5;
	Tue,  8 Apr 2025 11:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110455;
	bh=2z4IIA0dd3s1LhqIAzYeC5YsM6CQ5BkPuoMqRpzA/WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DnHy2+eUSFGBhA6gcMoiEAwEi+0B90BQkrGEiqRVyAogojkKErHT6+ghALl2AasGn
	 XTOQfqvbWEg4i98z9Jn5ZbIQyh3WVRt4WByEYZXoFjbLO1W4zkFgHAWd4x2QqA0zjl
	 K1gt+PqA2Fdgzak6+xrmhlmTo+UUJ9rxWh5+fyV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Maud Spierings <maudspierings@gocontroll.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 069/731] dt-bindings: vendor-prefixes: add GOcontroll
Date: Tue,  8 Apr 2025 12:39:26 +0200
Message-ID: <20250408104915.876890641@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 5079ca6ce1d1e..b5979832ddce6 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -593,6 +593,8 @@ patternProperties:
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



