Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063918;
	b=UBSMUUqjIyqbu2FfWgxvIDDYsTIyO3eMmAMFK1EGTTv1p0YVaCLgvuGOSoU7kMYTqdo/
	 YcCzAXEaYSePGdEqzSfaqUs0fCC6PoUe7BJvP4ESIACFf50RBDoEDp+DHbUHjhaB1Ya6W
	 f+QKOqWQ2Iku50xgdU4qkXYbtnpbCYt1JH3Lbx2KTBV4Gf1PfpT4yyOl8wBC9ePh9xLAS
	 eupb/Du7PzF/vcswm8NHWQJX95tKZAcQUJqvBI9T2dFwxJABZ1LJFRdbtzrFee9CneFHU
	 lESy8FsdAfTdc0S0DiNEniT55qNU9ukRs1pg0oqxfk4aLH6xaxJKyYG0GfUIu/gNvhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m1XjBtUVsajiSPN6eTNugYWT5fedzbOR4oBD8E7NAXk=;
	b=vSZV1JNIO0UFpviKOyieYMaeUMaoqY0H8n230x9iPZfl3tEKw54PmnsZgHHNvYObojVP
	 fhEEr/7/249ykQtgtlQ0vywYu7sjOs580gxfgNz4CmZi7PcD0+e7aKrFL9/fJcGLcMw+/
	 hKZIRskPyUFR2MQj/2Dlu2lh4JW+ii/d8NBVQnqyTYAMCAGnMN0PVbNDxBfye4/C9+0V2
	 BlnCHk3dAlHSHjEJsi/JehFwtMBhc6YmUE3gxBAHNUDA+YaT1AAnSxBRx7UqE2c0avMXi
	 jeUuY952iTH2VdNs7E/XfCXgrmLMsj8QMzH9UsREqltE8/8WR02QpMqRHBugBNU0odA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jDsA9ljt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF2B606E8E9;
	Sat,  7 Nov 2026 15:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jDsA9ljt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147FD1F0089F;
	Sat,  7 Nov 2026 15:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063918;
	bh=m1XjBtUVsajiSPN6eTNugYWT5fedzbOR4oBD8E7NAXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jDsA9ljt/cj7LkMQ/N84M9JARcM4VJb8FhIW+NrBXLB5L5uBiK5H+Pu4hYgBj4IPK
	 kxn+u6nYsiUUUGJE3rJUJME/Q7A8DgBreMdJkXS9f32DgS5vQzFVEh3Z8D/gmUD/VI
	 uRyph6k06ANwgz0xyCM/o/CwXuXG/D9CYR5PI9x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Alain Volmat <alain.volmat@foss.st.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0114/1257] media: stm32: csi: correct remote pad retrieval
Date: Sat,  7 Nov 2026 08:40:10 -0500
Message-ID: <20261107134942.495991166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alain Volmat <alain.volmat@foss.st.com>

[ Upstream commit b83651d321d4fd07979a59f359dcb0266391f17a ]

The function media_entity_get_fwnode_pad is called in order to
retrieve the remote pad, which is the source of the CSI.
However this function is expecting the sensor endpoint fwnode
and not sensor device fwnode as it is currently given.
Correct this by properly relying on the notified matched fwnode
data instead of the subdev entity fwnode.

Cc: stable@kernel.org
Fixes: dcb0f4c16be5 ("media: stm32: csi: addition of the STM32 CSI driver")
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/st/stm32/stm32-csi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/st/stm32/stm32-csi.c b/drivers/media/platform/st/stm32/stm32-csi.c
index fd2b6dfbd44c5..ecd0ed8e76b59 100644
--- a/drivers/media/platform/st/stm32/stm32-csi.c
+++ b/drivers/media/platform/st/stm32/stm32-csi.c
@@ -825,7 +825,7 @@ static int stm32_csi_async_bound(struct v4l2_async_notifier *notifier,
 	int remote_pad;
 
 	remote_pad = media_entity_get_fwnode_pad(&s_subdev->entity,
-						 s_subdev->fwnode,
+						 asd->match.fwnode,
 						 MEDIA_PAD_FL_SOURCE);
 	if (remote_pad < 0) {
 		dev_err(csidev->dev, "Couldn't find output pad for subdev %s\n",
-- 
2.53.0



