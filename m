Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0AB2EBB8C;
	Mon, 13 Apr 2026 16:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098197; cv=none; b=ctp12sUD3qIxfwjAm6606zIyaxb7k3saUNeJ6BJSiy9Otb4zx4KtyUBc8S4gr8E9avvVAI9dAMhQB3HpYzUQwsRK5TtohAVpKoBJpacY8wL1G6CyC4gjsH0JOqvR8OHDhRrD5Af3uSoSMgJsD7GEvaNZ+lzoLgEOyknqQ0RVapo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098197; c=relaxed/simple;
	bh=XJhOZqO3aZMyfRyBr31HgDaNLqc0os+2I6GIxOUvlYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQZSQmuT3KjKCy8IMHcOnp4Ii7BkFoG+chxn1iAOq/vDFY9UxfV84hJxPqsFa+1rsBANtX8iElDOYxEZrApjc4e4cGwHK62sxZRz7Qt7v4dXNAycROeT69KD8lepcI0kYpzZ6jc9riiMlqA8S0n9CxSmp1gWkH5aiyvL1jTv82Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCHsh3Ob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCHsh3Ob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C8DC2BCAF;
	Mon, 13 Apr 2026 16:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098197;
	bh=XJhOZqO3aZMyfRyBr31HgDaNLqc0os+2I6GIxOUvlYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCHsh3Ob33iroF+T9TA3mltyT9vc/r3q0criyaLaX/HgJUS0UKuXGxFjrGIXCs8AN
	 kOJNSrhESSJRn+VZHQ5owEQm/AydUvHtWGS1Xdku0ozzMBVyRpn7QCQjVuZpGC7zOS
	 LT5glG9AmV0U69/O2HhlFp3CYy3alTfg4hRLB3Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 404/570] dt-bindings: auxdisplay: ht16k33: Use unevaluatedProperties to fix common property warning
Date: Mon, 13 Apr 2026 17:58:55 +0200
Message-ID: <20260413155845.603707308@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 398c0c8bbc8f5a9d2f43863275a427a9d3720b6f ]

Change additionalProperties to unevaluatedProperties because it refs to
/schemas/input/matrix-keymap.yaml.

Fix below CHECK_DTBS warnings:
arch/arm/boot/dts/nxp/imx/imx6dl-victgo.dtb: keypad@70 (holtek,ht16k33): 'keypad,num-columns', 'keypad,num-rows' do not match any of the regexes: '^pinctrl-[0-9]+$'
        from schema $id: http://devicetree.org/schemas/auxdisplay/holtek,ht16k33.yaml#

Fixes: f12b457c6b25c ("dt-bindings: auxdisplay: ht16k33: Convert to json-schema")
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/auxdisplay/holtek,ht16k33.yaml          | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/auxdisplay/holtek,ht16k33.yaml b/Documentation/devicetree/bindings/auxdisplay/holtek,ht16k33.yaml
index 64ffff4600260..3ee00bcfcf827 100644
--- a/Documentation/devicetree/bindings/auxdisplay/holtek,ht16k33.yaml
+++ b/Documentation/devicetree/bindings/auxdisplay/holtek,ht16k33.yaml
@@ -46,7 +46,7 @@ required:
   - reg
   - refresh-rate-hz
 
-additionalProperties: false
+unevaluatedProperties: false
 
 examples:
   - |
-- 
2.53.0



