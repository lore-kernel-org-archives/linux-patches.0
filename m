Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618826;
	b=PkH0sIYVYUv0V+7H41tkJ/blJ1vEkBaOxGTEiN6xB1od7e/7FCbQYcVJUjVeIdPvY9WN
	 GTqSn7uTxzvJNBn0kB5+4AW3pKvW/c4KERNMJ//CXGkpVPP0lc1b1lyi3nQ4JFvcPcPds
	 A+sgAASLVAsg/n2Sv2cWsat9TY1doZ0acCCYlg1obeiIs7BKr+HLveTjf7XkdFmJfjHAu
	 ZQzHk4l83VYsHvuRyQQtfgjAh0yM2G6y9Q1l1P9Zwq91bnsIclGXmksj3+wztlM28VaOt
	 lwHS5XvkQzII0b3SxM6W8y4fnDXfueiSPpQFX3V6Yfmw/S40dAldHI6yvgeCl72coSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618826;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9ohTa7vuCKhVDwzJaDDVvaxAaBehMHwvekLuGujoKKU=;
	b=2gcqBBSZScIlLRfYCOX04an6kmhICg2hVcdzfSNScpN93B3xwKjzAq3zOyOuLgot2rt6
	 h6e90uTnP8mO3OUAH0f80ixaea87+MGxPSnEhg475z5bf7DCL/bX5DdVae43ra3TGHVI+
	 jKzdzpQD3pJ6//ze4YyRPRIGBSgvpjgY8G29bkp2s4ZgDAOfbCIUGAwk54yTJsDkuOpUm
	 quh+6bKmeW9Q2OOBKislGM99xfkmfE+Wk4EzqwYAki7Rxuo0wENhOBiUfQ+O2BQWR83jv
	 3OJhi0TXyLTzYkXh6EZ8kq0oAO7xtZFYA82KWDWhLW5007mpAsVsyE0v/2ARTKDl2tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CqJZthFI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB229606A327;
	Wed, 25 Nov 2026 15:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CqJZthFI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EFF1F000C0;
	Wed, 25 Nov 2026 15:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618826;
	bh=9ohTa7vuCKhVDwzJaDDVvaxAaBehMHwvekLuGujoKKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CqJZthFI0GvfGwTOgsEchLrnFZfNL0o/n0kvVZ7jLZVCQtDwoWsIpmwKvBQqGUsiz
	 dBBYwSf0MQh1w3z6Lbjh1yMagDRB/95MT1hgfbwU9N0/VqXbNcInA/E1QtBVM4BENv
	 5J1fESgf3Ix1tcRfP1DaTngN/EpQxtX9jm0tX0cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0399/1005] drm/xe/pci_error: Flush GT wedge worker before bus reset
Date: Wed, 25 Nov 2026 15:28:57 +0100
Message-ID: <20261125143831.091424525@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Raag Jadav <raag.jadav@intel.com>

[ Upstream commit 1eb526467c96ddaf87791c2b3cefa9f93ff45358 ]

With GT wedging now done async, make sure the wedge worker is flushed to
avoid side-effects during PCI bus reset.

Fixes: 13b9555ffb03 ("drm/xe/xe_pci_error: Implement PCI error recovery callbacks")
Signed-off-by: Raag Jadav <raag.jadav@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patch.msgid.link/20261022051303.282805-7-raag.jadav@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 0dbc1d0762bc89649aeaea98a63f6e5f786ea1b8)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pci_error.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_pci_error.c b/drivers/gpu/drm/xe/xe_pci_error.c
index e41af2ac7f23b..dc9d1be7857c2 100644
--- a/drivers/gpu/drm/xe/xe_pci_error.c
+++ b/drivers/gpu/drm/xe/xe_pci_error.c
@@ -29,8 +29,10 @@ static void prepare_device_for_reset(struct pci_dev *pdev)
 
 	xe_device_set_in_reset(xe);
 
-	for_each_gt(gt, xe, id)
+	for_each_gt(gt, xe, id) {
 		xe_gt_declare_wedged(gt);
+		flush_work(&gt->wedge.worker);
+	}
 
 	pci_disable_device(pdev);
 }
-- 
2.53.0



