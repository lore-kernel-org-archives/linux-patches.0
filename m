Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030697;
	b=Q2sdoH1xjvGTQ9nbNWDQa31YO9Z1vNdHGWGAk4kzJxkdZDNQ+XfRosrkx0tWI3lAMnGd
	 xJaKn/MqPVBAKETt/yG5BqhXrTFCaMGHTXGgOo6S699L8/6IR0PmZhmsE4C4ENH4RfU71
	 /Pik1jQWqKadTC0m0ew9VphyzqP/Xpt/uqenTNmM95b2jZ4dTBJjUD4RKj0hxJWg5z3Vm
	 Lq8bTZFL+Zv//ZvsoLNH45vHSHDdIaslsjL+rJDgEghKXiyjgPW9/xX/7LQBxcNONtYPH
	 TUNn6+0w5n11xHWPqwowmEGTZcuJp2tlKdZXFFJh2Ma821mU6MWtEY3Fqx+/2pvMyEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MwM1snRvu9OzxfEbNDTNbLlug0v5AF9zlHL+vnZFF08=;
	b=WbPa1Mq5iuX0UkZYpMtk91AQNaGt9UXfLU4PiUJ5BZbnLUo9gsnkuSttthLnRlJmTs7e
	 8r+bkcbZymbwqCkDniiMUPUJ/4vH9F4BHvue98C6MVWHMj25XpxL39uWv1RMivZdaixNb
	 GW2Xxs8Lz1FClxThStkGy3S3nuW2Z93/vj/6VoL1JxqNNW9h7cDIVcbSU+hXyHkhFSa5s
	 kiDXni6eJhxDi52JtSyzqsLzUOHkQSxVsmKCDro4GGHgnDG2vrgHcDk5W67q4uY6vr+zX
	 tFoAPLk5rlZtZLrL4RhdgtC6F8vudBf4QGtwrzEdl1Yjr/yU/pdy4hUyfZg42LkzjxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DCD8QmD9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E937606A33B;
	Wed, 18 Nov 2026 19:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DCD8QmD9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04C61F000C4;
	Wed, 18 Nov 2026 19:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030697;
	bh=MwM1snRvu9OzxfEbNDTNbLlug0v5AF9zlHL+vnZFF08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DCD8QmD9FBKSZ7pIHIh8bh2QONWWf3H0Ul2u1ra6Je/bEqr+h8dG41QYaEZ9FIPaF
	 8Da2xqU6z8xAN55Xc3vYE7/bzkFXbHftGXTJtLulZUlthSitc1PVs3cM7aZ9fItcLP
	 rZwfbIUWOz/QSX8dpASMdqKccQQS1rmbmhRmSfzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0797/1756] scsi: scsi_debug: Validate the access parameters of WRITE ATOMIC (16)
Date: Wed, 18 Nov 2026 15:48:44 +0100
Message-ID: <20261118150041.426924005@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit a6c339feb830daa097ccc4c50c339c1733c12d42 ]

resp_atomic_write() validates the fields that are specific to an atomic
write, but never the range that the command addresses. Every other command
that writes user data calls check_device_access_params() first, which
rejects a transfer that ends beyond the capacity of the device, one whose
length exceeds the size of the store, and any write to a write protected
device.

Call check_device_access_params(). The zone checks that it ends with are
unreachable, as atomic writes and ZBC emulation are mutually exclusive.

Assisted-by: LLM
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.garry@linux.dev>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20260929082456.857423-28-cassel@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1d9947dc14351..0906ef5d7798e 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5385,6 +5385,10 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		}
 	}
 
+	ret = check_device_access_params(scp, lba, len, true);
+	if (ret)
+		return ret;
+
 	/*
 	 * Short atomic writes are not allowed: SBC-6 4.28.2 requires an
 	 * atomic write that cannot complete to leave its LBAs unaltered, and
-- 
2.53.0



