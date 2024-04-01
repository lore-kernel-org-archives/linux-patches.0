Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C0D1CA8F;
	Mon,  1 Apr 2024 16:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988692; cv=none; b=PIZosGaUTAyMkyKXu9eRA7ytZPuQKIQpAb26a8mlgvEo9RB6ivcD772jX/8hfB9c/qMVcBF/Lj90s+XVF6tp7LPTDRKwNB7SPC3LtU66Tant9L5hD25Fg2Z83meOqbmCAzrl5JsIGiph6C89bqksHsqXa3HafNS/GbQx5vIVZQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988692; c=relaxed/simple;
	bh=KirYtTUyJ0yyNTpe5OjDAtrMQGdyAurcuQEMMN3SZhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ywy4a4zycApNvmv/cyqVpYY3aqQX114nU2Flt/XTzKIR2SpKYPkkZYvvnDkVcPGisAwJVHi8WBtXtHp8Gvd5oxbImTI+xTv3rn//FntAc4jEI8asYG8jYNC3WyyR0a6oQMvMqiowT4dk8o7CwpbktQQ8BnhZLC4hUkgW2EdwZ3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qL/J+4G8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qL/J+4G8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9951C433F1;
	Mon,  1 Apr 2024 16:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988692;
	bh=KirYtTUyJ0yyNTpe5OjDAtrMQGdyAurcuQEMMN3SZhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qL/J+4G8Qjh8RopsnhlEfUk72gpViyuxa/yJv43Yn2iECNylE6e+ljm3pkpttBEFU
	 jQ3eRxLKETTMAKDub03q4WD8VcSi63riV6iAZoCKtobXArMdg+lzNgG41DDJrT+poY
	 NLFvt+QodDM9TlSsbFuq/NfBST+rvagOKc/XYt7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Audra Mitchell <audra@redhat.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.7 232/432] workqueue: Shorten events_freezable_power_efficient name
Date: Mon,  1 Apr 2024 17:43:39 +0200
Message-ID: <20240401152600.055750002@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Audra Mitchell <audra@redhat.com>

commit 8318d6a6362f5903edb4c904a8dd447e59be4ad1 upstream.

Since we have set the WQ_NAME_LEN to 32, decrease the name of
events_freezable_power_efficient so that it does not trip the name length
warning when the workqueue is created.

Signed-off-by: Audra Mitchell <audra@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -7109,7 +7109,7 @@ void __init workqueue_init_early(void)
 					      WQ_FREEZABLE, 0);
 	system_power_efficient_wq = alloc_workqueue("events_power_efficient",
 					      WQ_POWER_EFFICIENT, 0);
-	system_freezable_power_efficient_wq = alloc_workqueue("events_freezable_power_efficient",
+	system_freezable_power_efficient_wq = alloc_workqueue("events_freezable_pwr_efficient",
 					      WQ_FREEZABLE | WQ_POWER_EFFICIENT,
 					      0);
 	BUG_ON(!system_wq || !system_highpri_wq || !system_long_wq ||


