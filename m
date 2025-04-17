Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7238E1E1DEF;
	Thu, 17 Apr 2025 18:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913074; cv=none; b=tEJ4MduryaLARp5CevB0+POLNX5XnkfK7VDkzUNbnbe2mA6UgPJQO4+3VxY0RNJDBL+Ky9VfstJeI8EXtkdVX3YQa9E5U2ExdtpZDL7DcYDSh3TIfONrGq6sNOtA44NO5/V6/b5TUwkjTF9U3HicXLMFyXapCNiaQCnC3bi0dQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913074; c=relaxed/simple;
	bh=5cxbJ4W1YK349dp9pAIoZ9+dWl22Yhn7u7K19GwGS5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J1a33HZE+1oTC7DnShWMzCTjrxr3sIpw6LRB+qapMQhJUnPcR2Uw2dYUi6iu57dV5TbH1VBmwN16x+c/h5YN22SkFzMOSvCr8gyaUW5WCEzREyckjW/u3vHCrN0QwgTQ0/xZ0h19M1y9HEtjMuzqPyZBvUl//e7dtFEcV7RmjD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkc8WfNE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkc8WfNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FA6C4CEE4;
	Thu, 17 Apr 2025 18:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913074;
	bh=5cxbJ4W1YK349dp9pAIoZ9+dWl22Yhn7u7K19GwGS5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qkc8WfNEs+8yI69gA6mEn8AySXDVZyoZ9PY3Vkf4PnB97P5U/FiqdQmKjtCaRw/Bo
	 LIXKrw6IhY44lvEn/dTG6fO27xI13y84wsUHqe5l/BVk4r9nAOqaowpwRDGFQNulVZ
	 72zlkhdgpt1omd6sDaBcn48dRq9IseMxgS+QdiIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 218/449] dt-bindings: media: st,stmipid02: correct lane-polarities maxItems
Date: Thu, 17 Apr 2025 19:48:26 +0200
Message-ID: <20250417175126.747244317@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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


