Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D800719ABC6;
	Thu, 17 Apr 2025 18:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915680; cv=none; b=QZCWMFskxCCGIoR14LlsTRWLGFOiujUIUvp7VXMl2M+hEj0cEpASiQV2W6Ju85u7ke9ikeqVyOiv4MFwg4hJO/mPo/lYoa/aPk4dcD9VVGX1VYU2JuXoSd3ZXKtg35z6oyqYlJf+zBgSTgDB+aqgwgYyIeVtO6DdQ/FWpKC1kxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915680; c=relaxed/simple;
	bh=uwqLWvZKTDi11E2Ij+8M+FKnUDK633RBKZNPhrn6fag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaOZW4PjY3aqb8ducXfymzH8yNJzqjfiUAehJIBtDqlIjwRZpCTxpHrgDLcw5ZC2YLP440BcEVUl9b65yogR3LhRG5GM1IEEJhhHQtuZbaEeJ+nrAO2zEllf7uAN1XX1xkk87kCDn0TASVUc8Pd4ildqEwRLr4nlEtfM/h4ztag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/JzCV8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/JzCV8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26CDC4CEE4;
	Thu, 17 Apr 2025 18:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915680;
	bh=uwqLWvZKTDi11E2Ij+8M+FKnUDK633RBKZNPhrn6fag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/JzCV8t66RKWrjHW/yKVtnCVBDEH10yp6P0ls6V8NyzRpU/sYChaRPb24+2WR5pg
	 5z6uNYpbwQj4VP8qYoysvk69u1AzH5qIogYiL1Tkas/61nanMu3IY3/AMVczzGxF6/
	 POEFnykb7NeR1iW9YGXdNTufN7V1ipg/2piEmcc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 188/393] dt-bindings: media: st,stmipid02: correct lane-polarities maxItems
Date: Thu, 17 Apr 2025 19:49:57 +0200
Message-ID: <20250417175115.151211389@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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


