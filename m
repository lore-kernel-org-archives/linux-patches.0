Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAF3143757;
	Wed, 19 Jun 2024 13:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803466; cv=none; b=PmEuDn958DiPskPgqWxOpMdaK4grAE8b5YeWA7XEQXBzp/NWLNPlEuzYb9/27oRys5hOq7hhTqB4ETOX1R9YjG9EaXxearwbLCWJ9dGvt6knTgxQTVLwCBduzk52mpux+YLlSU5hE9FumWHHDSVhfkvoGRTKGPJBr9XsYMDg/Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803466; c=relaxed/simple;
	bh=Tiu7YgyUfTPRoFXxUqwZG6rOzIggQOQvJbu8j8S+ifM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpQvUFUX2KTvzasB5k+WYwfjs2z1WRDVM/e7TAwn4+aVqIwLoPG8qJkpsC9kQHzgSiY3OVOpryOMbiR7CsNukNgct+pkfJScZtvz71lXdW04ifAjhd6GkrM3SWz/vX52H+WiJCa8LIOgj2U/ezVSSkzSqSdCAacScwZf6OnDgGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQJF/IoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQJF/IoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E3EC2BBFC;
	Wed, 19 Jun 2024 13:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803466;
	bh=Tiu7YgyUfTPRoFXxUqwZG6rOzIggQOQvJbu8j8S+ifM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQJF/IoGpYYPcBmZIeX12Jkf/Z5aarqz5m9yz5JITNRE8WI4lnKi8tW7zSQx8699j
	 I0Wr52FpgxYSuHNSqO4VhIl/xAhkuruFXKuHV55eWCE7vQk4NSHXSl1HvgZoyDdMwp
	 ncxW1ZIIM2FRGy3Uufk9zn3uBYQ+ZuhJjrwmzVhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Stephen Boyd <swboyd@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 275/281] dt-bindings: usb: realtek,rts5411: Add missing "additionalProperties" on child nodes
Date: Wed, 19 Jun 2024 14:57:14 +0200
Message-ID: <20240619125620.563240615@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit e4228cfd092351c2d9b1a3048b2070287291ccbb ]

All nodes need an explicit additionalProperties or unevaluatedProperties
unless a $ref has one that's false. As that is not the case with
usb-device.yaml, "additionalProperties" is needed here.

Fixes: c44d9dab31d6 ("dt-bindings: usb: Add downstream facing ports to realtek binding")
Signed-off-by: "Rob Herring (Arm)" <robh@kernel.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20240523194500.2958192-1-robh@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/usb/realtek,rts5411.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/usb/realtek,rts5411.yaml b/Documentation/devicetree/bindings/usb/realtek,rts5411.yaml
index 0874fc21f66fb..6577a61cc0753 100644
--- a/Documentation/devicetree/bindings/usb/realtek,rts5411.yaml
+++ b/Documentation/devicetree/bindings/usb/realtek,rts5411.yaml
@@ -65,6 +65,7 @@ patternProperties:
     description: The hard wired USB devices
     type: object
     $ref: /schemas/usb/usb-device.yaml
+    additionalProperties: true
 
 required:
   - peer-hub
-- 
2.43.0



