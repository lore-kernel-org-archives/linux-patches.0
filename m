Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADF818C2C;
	Mon, 22 Sep 2025 19:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570447; cv=none; b=VRdrzY4i9z2zvPG1qNvX9y1Hm/ku3zPR3IFnHgHC5GG3XwpJqjxGT+NVWdKjGhNgTyKnZh43JJ8s1WK/BUcdyo7FFOgyZQIZekJ4eG3pIkcENczUohjIeK45R7gajj7/Pkf3JUUsgJWJOMt853pNqijks4GfKpQk11mXE5Ytu6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570447; c=relaxed/simple;
	bh=jaCLVCbdtZhdlk6BsJs8YPgKAW4XZpzNjYFfJKQvgfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxe8DQvOsbRAnQGYV8KtOTnzu6JOSZPjqWwHnN6/Cx206qdiIIFu0bNPynPqfBZFlrm4mLDH6V57JC/+TJ8XG61Djc5MuUcvug4HhU9kgjqs9NwYSy8z3mWPn1RbDOepnNKCFFo84QBDv9Is7bVsF+h9T2z18qUtK18oVq8l+yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+k+UpFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+k+UpFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F72C4CEF0;
	Mon, 22 Sep 2025 19:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570447;
	bh=jaCLVCbdtZhdlk6BsJs8YPgKAW4XZpzNjYFfJKQvgfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+k+UpFHoPqK7aR40ywBtnSmqGkwITq95Z4cBujZ9AlWQtClfP7RZfrJRyFBYH/0a
	 PxRLhckOit4wSI7gPBhEer36bV1e9DleztnKaMZh0Q8EUDIc/uKSz3l8mITSEt0hps
	 IITJ5w8H71pCnPjZurZLGWlpHZsGi0Kh3OVE10Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yixun Lan <dlan@gentoo.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 143/149] dt-bindings: serial: 8250: spacemit: set clocks property as required
Date: Mon, 22 Sep 2025 21:30:43 +0200
Message-ID: <20250922192416.475749727@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yixun Lan <dlan@gentoo.org>

[ Upstream commit 48f9034e024a4c6e279b0d040e1f5589bb544806 ]

In SpacemiT's K1 SoC, the clocks for UART are mandatory needed, so
for DT, both clocks and clock-names property should be set as required.

Fixes: 2c0594f9f062 ("dt-bindings: serial: 8250: support an optional second clock")
Signed-off-by: Yixun Lan <dlan@gentoo.org>
Acked-by: "Rob Herring (Arm)" <robh@kernel.org>
Link: https://lore.kernel.org/r/20250718-01-k1-uart-binding-v1-1-a92e1e14c836@gentoo.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 387d00028ccc ("dt-bindings: serial: 8250: move a constraint")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/serial/8250.yaml |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/serial/8250.yaml
+++ b/Documentation/devicetree/bindings/serial/8250.yaml
@@ -272,7 +272,9 @@ if:
           - spacemit,k1-uart
           - nxp,lpc1850-uart
 then:
-  required: [clock-names]
+  required:
+    - clocks
+    - clock-names
   properties:
     clocks:
       minItems: 2


