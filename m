Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A616253F29;
	Wed,  5 Mar 2025 18:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198674; cv=none; b=PfXUok77GK4AvYwUc2T3qCGNSREpl6wqpvmifcb+mtRQYfvXu4KCJVPQqtUXyd3xGCu2e8VOl+e0NbVbIJl8WoF0HRuSwa9zv029yRXniuAMuQ9bDqXpuCCZklsqgJpygw0XSQagF0bXP2Z7XfNavURpvI77diAU7yRrRH4ueek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198674; c=relaxed/simple;
	bh=aIF810AYyM4TKpfnfxugQ472Qo9W6xw7wuYDa8k7Yjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZJ4OCYH6BOhQV2m2681ksSR6f/WWW9RhQvZq/PxjbeJdYmO+vlio3wZDB33vOnw1XM8iDIUuWq7wSkA7r3ks4jc/W8WGa6y3uZoowNhRy7uDWse0zIU4FUmosEh4ujVBAwxyMWozfzkSsFVx+iE0JeBzk/IM09vulJbZ96UsU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x04DUYle; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x04DUYle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB84C4CEE0;
	Wed,  5 Mar 2025 18:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198674;
	bh=aIF810AYyM4TKpfnfxugQ472Qo9W6xw7wuYDa8k7Yjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x04DUYle1EO49GPh+j4UrLG+6gUwpFK/g+BiKWW+g+kA5JYddAxeEG+HpqK6sLD98
	 3RIJf7B/znU0OMc3t2T4bvB80F+guFb4G7RP7/OlYg/OZu+/wC5K2zxWWcLCXjJs/W
	 /lAP90YN8RvXxbO4ZNSkzp5MYOtv5q9SCxhDQIcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanket Goswami <Sanket.Goswami@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.13 109/157] i2c: amd-asf: Fix EOI register write to enable successive interrupts
Date: Wed,  5 Mar 2025 18:49:05 +0100
Message-ID: <20250305174509.691948430@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

commit 9f3c507cb44498067c980674139bcad56e582ee6 upstream.

The commit b1f8921dfbaa
("i2c: amd-asf: Clear remote IRR bit to get successive interrupt")
introduced a method to enable successive interrupts but inadvertently
omitted the necessary write to the EOI register, resulting in a failure to
receive successive interrupts.

Fix this by adding the required write to the EOI register.

Fixes: b1f8921dfbaa ("i2c: amd-asf: Clear remote IRR bit to get successive interrupt")
Cc: stable@vger.kernel.org # v6.13+
Co-developed-by: Sanket Goswami <Sanket.Goswami@amd.com>
Signed-off-by: Sanket Goswami <Sanket.Goswami@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Fixes: 9b25419ad397 ("i2c: amd-asf: Add routine to handle the ASF slave process")
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250219135747.3251182-1-Shyam-sundar.S-k@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-amd-asf-plat.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-amd-asf-plat.c
+++ b/drivers/i2c/busses/i2c-amd-asf-plat.c
@@ -293,6 +293,7 @@ static irqreturn_t amd_asf_irq_handler(i
 		amd_asf_update_ioport_target(piix4_smba, ASF_SLV_INTR, SMBHSTSTS, true);
 	}
 
+	iowrite32(irq, dev->eoi_base);
 	return IRQ_HANDLED;
 }
 


