Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F334D3D75AF;
	Wed,  8 Apr 2026 19:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674856; cv=none; b=bsSKxcv3D40+Roetx9mPBAgFoDQ8L0aYNOhiUQjdcANjSLFlWERl0NJ8D1Z+hdSJr+u0nFzf5J8MhDoBgMZFByafOtjrZ8rRcpg/9pIfZ+yGO3EGPgI+0kpqZD6eLU2zDV9UT9jFGfW2XmMAXPxdT0H4WHDj+Z0X/P8uKjZDO8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674856; c=relaxed/simple;
	bh=Y9wOola1C63umNaqrTlUH3VJQlqxe455L68E2GqjXP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKvj3X+GmqUig1H8DXqtSNyxUHGoh3xT05YqecaJGXh7pxaZVCIrtomKOyO9NdYoVS/jLviB2zQ+FJUpxF4J0r17SzZn4J9EJyD6s/m2u31YRjSC8ckG9Otk6PKQS7/D8QlXZBIhVM0W8Hp+gztW+QUvSG/bLj69g7w9txacHPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2S6ymbF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2S6ymbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8938CC19421;
	Wed,  8 Apr 2026 19:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674855;
	bh=Y9wOola1C63umNaqrTlUH3VJQlqxe455L68E2GqjXP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2S6ymbFrNlSK3WQ5BoVI+2ME/aUJoHDRYGlA5EwMjppgmpId16LXfmPztYpyU8SA
	 q+MymHmG6ogdX5QhsgD7yNeP2fOuB6zyeywcSgxV6bdgn2WccypDRlhP/mWxyuHK3U
	 hynMzOa9OYJjLcWLQmfGam/1+myqQedBL4NKp7Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.19 260/311] dt-bindings: connector: add pd-disable dependency
Date: Wed,  8 Apr 2026 20:04:20 +0200
Message-ID: <20260408175949.093950884@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit 269c26464dcf8b54b0dd9c333721c30ee44ae297 upstream.

When Power Delivery is not supported, the source is unable to obtain the
current capability from the Source PDO. As a result, typec-power-opmode
needs to be added to advertise such capability.

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://patch.msgid.link/20260330063518.719345-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/connector/usb-connector.yaml |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/devicetree/bindings/connector/usb-connector.yaml
+++ b/Documentation/devicetree/bindings/connector/usb-connector.yaml
@@ -301,6 +301,7 @@ properties:
     maxItems: 4
 
 dependencies:
+  pd-disable: [typec-power-opmode]
   sink-vdos-v1: [ sink-vdos ]
   sink-vdos: [ sink-vdos-v1 ]
 


