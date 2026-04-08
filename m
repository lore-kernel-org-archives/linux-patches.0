Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4933624B9;
	Wed,  8 Apr 2026 18:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674105; cv=none; b=bGFfSyCDXFhRZw7KcNlskGvRIvyTWcbwqa2YVswHawtFy8lHpSNPTzSTMfatqg07EO11HneFP3a+OABxzc8yXvx82T49FbPUxOZdg9kXRDU/so/LrnZrsCivegqql+kfgYv88TaKpMfXTY4/l8wSID8Rc7VU+kgoshyXpyKwhZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674105; c=relaxed/simple;
	bh=dE6icxJbF6d5v/qMHYUsRZGrNOpgRC+ctj7DRVYb8oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTWX9lEBwMm5U90XluAL/ysXLdXj9AiE9ZHoOd+F9kKmeaNN98Z1P5Og2tyZnNDXy2sFQz+9nYSckUSXnIZ4g/LlVn81GgGQvhuGi0Ov+Oa53KAV5C0Sfsfvja/qdoyrh2M5y4w26sf+Y2dPaHHtKB8h9P4tAD7aXRGE4lMIpDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=msQahyTf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="msQahyTf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67D0C19421;
	Wed,  8 Apr 2026 18:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674105;
	bh=dE6icxJbF6d5v/qMHYUsRZGrNOpgRC+ctj7DRVYb8oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=msQahyTf+w67dzrfRtA860OSqaJG2mw2/RLWrk5PcjU/W93S9yhDjI7+ajPg41L9Y
	 6yJUQBxJaise1HAxuQXylULbahvIYP7sne5683r/RhBLeEg8TejBdhOKCkftqqKa0H
	 inhQsR2oep5R0dVYFgclfPtZTsUX+kQEKqSBB8Jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.12 179/242] dt-bindings: connector: add pd-disable dependency
Date: Wed,  8 Apr 2026 20:03:39 +0200
Message-ID: <20260408175933.784804036@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -254,6 +254,7 @@ properties:
     additionalProperties: false
 
 dependencies:
+  pd-disable: [typec-power-opmode]
   sink-vdos-v1: [ sink-vdos ]
   sink-vdos: [ sink-vdos-v1 ]
 


