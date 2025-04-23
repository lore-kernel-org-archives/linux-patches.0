Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5BB28D82C;
	Wed, 23 Apr 2025 15:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421052; cv=none; b=dHXLnN8ojKW40U92MVa1I2xg70NFnL8Fma2XkIF1d09VYe2ffmNzSwF9KzGrk76mMOprGaZMVAkYL6xU2LhNxUddOa1BuemZiU5YmjnATjrrJY+bHmbWFsTBczm7yC6P+XE0POuzkINRbcYPMx8vNWVpyAuQRaTNKXzVRiwB1OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421052; c=relaxed/simple;
	bh=Lqk44TJU+GmLGuX1etduVE5d9J5VhKGH5oLxCkTqnAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TE0iWcKtKkXXZL1JPSjFK4K3iPqWslkq0z6tegjZfzuCRNskfEy8V5fNItTO5SwDaJ5O95JpNvCpTTaA9VHLSBDJz37KVPXn9mHsk8jZobb4WVWtBGyMgcKk20NVGSgQuXj2ldmnQIglmYUSQMoulI7KJCe9b2X4wiVNlsRWXOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1cb1M2eC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1cb1M2eC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE191C4CEE2;
	Wed, 23 Apr 2025 15:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421052;
	bh=Lqk44TJU+GmLGuX1etduVE5d9J5VhKGH5oLxCkTqnAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1cb1M2eCt1VLCz6fos6SsoIWnFgdf6uG7r8roc8LHKii4kiBsGTxOy61CEdrLi3yl
	 f1J/Ayc2PkkadUmCD4/D8X30QKo6vdvKKdXTneE9wfXDOgCPMrFepIaMx/5RKiPRzn
	 BTwcsdR+dvy3WnVAbm3KBqgpLPjz4ucUEWzQzmvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 119/393] dt-bindings: media: st,stmipid02: correct lane-polarities maxItems
Date: Wed, 23 Apr 2025 16:40:15 +0200
Message-ID: <20250423142648.272503444@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Alain Volmat <alain.volmat@foss.st.com>

commit 3a544a39e0a4c492e3026dfbed018321d2bd6caa upstream.

The MIPID02 can use up to 2 data lanes which leads to having a maximum
item number of 3 for the lane-polarities since this also contains the
clock lane.

CC: stable@vger.kernel.org
Fixes: c2741cbe7f8a ("dt-bindings: media: st,stmipid02: Convert the text bindings to YAML")
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/media/i2c/st,st-mipid02.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/media/i2c/st,st-mipid02.yaml
+++ b/Documentation/devicetree/bindings/media/i2c/st,st-mipid02.yaml
@@ -71,7 +71,7 @@ properties:
                 description:
                   Any lane can be inverted or not.
                 minItems: 1
-                maxItems: 2
+                maxItems: 3
 
             required:
               - data-lanes


