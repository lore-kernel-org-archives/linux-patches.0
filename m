Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9E8B67E;
	Wed,  8 Apr 2026 18:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672737; cv=none; b=ZRoDZd1eyH4PPUNKH5rYW9s+Pa60kd0eE+A3i0+dFhOkOJQoQVYzD6i4PLA0+7TK2MKISK5xuqgRY6LbJ51nW2Nj2SwkpB+rF16vHux+kDokF1ketYm4ZmiQdqWeozslvZVRCIApDtCAFfBUFVaJDWad4XSQjvp1tN05DQ6IH8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672737; c=relaxed/simple;
	bh=f2CAWYZfP4DBMCMxIbg+I1kvaXksuFeQljbnc6PgI5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZkXucdFDo2CCDzjYYaJILQSciqe/zzqaEByGCH3pA3TnLdMJOI5799R/4g93/FHGa7+/WONkkqkvtt5tMwGBGewEs17WQknhGF+6CZVmgmZ1BaTSEuFohk14ndJ+bvH6HOLxy7xQ1+JYyfQc1KwxILaOcISTb1fWi83A7/8VJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SPgLkRPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPgLkRPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A64C19421;
	Wed,  8 Apr 2026 18:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672737;
	bh=f2CAWYZfP4DBMCMxIbg+I1kvaXksuFeQljbnc6PgI5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPgLkRPmKS/ktHfzAHBeaAZhpZFh7h1UVblBx2cVx5U8mPMleKpYyUFjJuYvxoQvA
	 iM54waDE2Vr7zLY3/h4RCtN2Ovk5ETv890Pr1mqOhuwpIYz9Kew+asI+h/+Z5ud5MN
	 VBiNXiYjQKW4Cs4J04A8F6gqZ3ZknpDRh5F1KiGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.6 122/160] dt-bindings: connector: add pd-disable dependency
Date: Wed,  8 Apr 2026 20:03:29 +0200
Message-ID: <20260408175917.746406411@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -232,6 +232,7 @@ properties:
     type: boolean
 
 dependencies:
+  pd-disable: [typec-power-opmode]
   sink-vdos-v1: [ sink-vdos ]
   sink-vdos: [ sink-vdos-v1 ]
 


