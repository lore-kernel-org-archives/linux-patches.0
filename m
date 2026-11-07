Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062941;
	b=FimA1+mQotIeITeMBMOa5/GQ125+//JLcPbW2qxEk/VodKIWfEWrDpN3HxFVcFnxjxjR
	 8qm4G+5AMRIxlPq/QrwhxRj01l6S7nFTcZ8qLzk/9ai0JxN+wW6zKa2fRj9XO09UmMXbA
	 aYaUG5I2ROMfq0qgpCnNxGau2yNu5P1NtoCm9wNZ61VaPF/bVqN3h7tX9bmS6A4IeVoYu
	 V2dZU9X3RiAuw7Ij9R2OrfsRwgOxA97CV7GGFc+H1GuUKReqhYzAUpaOJhxZfxzWlZ1CV
	 2wWp1SzKORvl3dGWylL0dgKPF9S0b6Z4YV1x/bduost6IkQJsmfoQdjQOhtRU9SlgJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oBuYbHxpLvK//A4k5slK+jfYmeKnwBUSfrwCDwZkP+k=;
	b=xBhSemIgzF7n1Y+/wAAehmAqAjiLz867aPpdcT81RAoTCIH70+Wj3GC7OTk8B3+QpZF1
	 jmiY0o+bt15B2Bj9fIK3UtvCxsJzYTBsAfZTNy/gff2FK7zOg8O2lwtvSKon/HJgLKi8y
	 maKLLQVAHjUOZwhgerQtuvUsA8LgMM6slciv2wgOXmiFH8HUMwPVJxk4gN2MWr5h4wjiC
	 9ftRg2aC0Y+LJyBYvYw8MT+alELwbzgJ/df4utcckjSVzS39kClYXHcUzukuXfe12TbHf
	 7rL50a/8NMI5xY/sUqs/Npqfp3ioqyuocwJHlkYP8zYtp0JBot+GS81W5fmVzLByRSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lJKKoymC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623EE606A326;
	Sat,  7 Nov 2026 14:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lJKKoymC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF741F0089F;
	Sat,  7 Nov 2026 14:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062941;
	bh=oBuYbHxpLvK//A4k5slK+jfYmeKnwBUSfrwCDwZkP+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJKKoymCcoRIdNnJDFmLfCVRr/L4GKAYGN3xGHvwy815kxiOF5MLBzDm/jhcJOof4
	 Ywy+C41vwhAoU2Zx7eeVRRgdc0rYFcjXgf44233JxL/I4gpIyW14MojsH7PtHO+2KA
	 T+5Q2+DxgHpWk/EccZLaEKCYvozvv95b1mXSWvbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 182/869] media: ir_toy: Validate the maximum tx carrier
Date: Sat,  7 Nov 2026 08:47:44 -0500
Message-ID: <20261107134858.307651753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 27303392aa87b61692faadec8b00e0ca66bf98dd ]

Reject any carrier the hardware cannot generate. This also fixes
a divide by zero if a carrier of U32_MAX/16 is set.

Fixes: 8bff1386d62d ("media: ir_toy: allow tx carrier to be set")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ir_toy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/ir_toy.c b/drivers/media/rc/ir_toy.c
index e79de56997a42..ba6c042127078 100644
--- a/drivers/media/rc/ir_toy.c
+++ b/drivers/media/rc/ir_toy.c
@@ -373,7 +373,7 @@ static int irtoy_tx_carrier(struct rc_dev *rc, uint32_t carrier)
 	u8 buf[3];
 	int err;
 
-	if (carrier < 11800)
+	if (carrier < 11800 || carrier > 3000000)
 		return -EINVAL;
 
 	buf[0] = 0x06;
-- 
2.53.0



