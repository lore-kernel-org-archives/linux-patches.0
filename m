Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E172D9780;
	Wed,  9 Sep 2026 14:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962632; cv=none; b=UX7ayat4nOKgH8YOq3tCGX0WtuV4f2MwUsmQsUUNg92tVHskYI7mFi1Yet+eJjSQYS+Vspp8DgyR3PTm1gT4OnPkS2FV+sdW59e9dpynGz7+eNEZltdNMnxqW3ZVtWKkVrnb0hCJztzkdHBxYp6SgoxNK9WBlyPfmjL6dO1oy0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962632; c=relaxed/simple;
	bh=PuPmrOoM+GXwzvmkHko5/u7z8UjhDYorOK/nkQpP+nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kIlKQuHZw97jE7GSBkKphkFH+TsMxBE9Uul5oEb7QdCC/9H+EJBR5Tw8RueE+9Yu25pLi9yr8XJl6tIwfAfxIGOxvcuVMRPm9pOd9rK9F0sS603tju7bgd4ArZUU9yyhT3h3TnDAjeHH8HZXORuseh9FWekffT9NwEFLT4wSF/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7oefaw8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7oefaw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8EC1F00A3A;
	Wed,  9 Sep 2026 14:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962631;
	bh=ZOpsq2HKHofkPaqoPuXzRyD/Z8if1xcQgYBGP+kXLPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7oefaw8uq6s1TWA6KFqLzhM6O8VWMrbOinjZu89C19+hHk0ely85USuTY7I0G+Tz
	 jhXpwxb5WUIIz1K/qNbburnpdYYnLaZ516uCDdOAawi45+MTND+RmF0Y7iKmjhCazk
	 zbZXDz5s9gUIaispXv+8wVS6KU9ks2NrUy3tQpCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 358/556] media: dt-bindings: nxp,imx8-isi: Drop fsl,blk-ctrl requirement for i.MX8ULP
Date: Wed,  9 Sep 2026 15:40:38 +0200
Message-ID: <20260909134243.264466918@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoniu Zhou <guoniu.zhou@oss.nxp.com>

commit fc312f830d8df6c082bd6f7250aa5c0ff063eea4 upstream.

The i.MX8ULP variant does not require the fsl,blk-ctrl property. Add
fsl,imx8ulp-isi to the exception list alongside fsl,imx91-isi.

Fixes: 288517a3c6c9 ("dt-bindings: media: nxp,imx8-isi: Add i.MX8ULP ISI compatible string")
Cc: stable@vger.kernel.org
Signed-off-by: Guoniu Zhou <guoniu.zhou@oss.nxp.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20260424-csi2_imx8ulp-v12-1-da148eabc035@oss.nxp.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/media/nxp,imx8-isi.yaml |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/media/nxp,imx8-isi.yaml
+++ b/Documentation/devicetree/bindings/media/nxp,imx8-isi.yaml
@@ -117,7 +117,9 @@ allOf:
         compatible:
           not:
             contains:
-              const: fsl,imx91-isi
+              enum:
+                - fsl,imx8ulp-isi
+                - fsl,imx91-isi
     then:
       required:
         - fsl,blk-ctrl


