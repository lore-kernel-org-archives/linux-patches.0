Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95DE268685;
	Tue,  8 Apr 2025 12:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113809; cv=none; b=g4alshDohb61+OlLiJHT735DE5+o3Hqk6LuJKLZJqcyvcwRbQgs5skhznHPglYP4B3kgwCY/RHYPkTQ50owF1ejs+8HiYF4xW2MVIjAB517cEacKV/v+wvkZeOeoG/ukBzVwLHyxcnva/KDWi8fHF+X7OWsI/5aQpkcqHXAxpug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113809; c=relaxed/simple;
	bh=Kd1zjVAC2lE+6G+MAu0qIvU08toGIHpuRLkdG4qZrWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQMb1Y7vT1t33ecZ6x74ix5rtqR9bOvjKkSvbza3v2X/qt47nnmt6pHNDtgmfKxNEbGg09ie6eEHo1VmCwpYio9W+mnbpBrBRdbBXD1orMKP6ueJgZbbkwolN/TObNvmXLPVPIwi0qkjXcheh+sW6xmz8EhA4s+lodx8HV/AQos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSB+702l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSB+702l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A10C4CEE5;
	Tue,  8 Apr 2025 12:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113809;
	bh=Kd1zjVAC2lE+6G+MAu0qIvU08toGIHpuRLkdG4qZrWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSB+702lIEmZGGIqNVTWfo+ENCWc/LYuX2SxmPCb8YDOmVrTHgqYSEIeSgJUrxTFl
	 mLPdMSJJS1/ok7nuOGh3xdgxzN66x/NTV2lB9nNt21kp4IRTloVonltkjKcL+GEq8F
	 ZDlK1gAmx9n321ef+K7//QvX8TE7xNsbsNcztlDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Magali Lemes <magali.lemes@canonical.com>
Subject: [PATCH 5.4 005/154] Revert "sctp: sysctl: auth_enable: avoid using current->nsproxy"
Date: Tue,  8 Apr 2025 12:49:06 +0200
Message-ID: <20250408104815.466292312@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magali Lemes <magali.lemes@canonical.com>

This reverts commit 10c869a52f266e40f548cc3c565d14930a5edafc as it
was backported incorrectly.
A subsequent commit will re-backport the original patch.

Signed-off-by: Magali Lemes <magali.lemes@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -326,7 +326,7 @@ static int proc_sctp_do_hmac_alg(struct
 				void __user *buffer, size_t *lenp,
 				loff_t *ppos)
 {
-	struct net *net = container_of(ctl->data, struct net, sctp.auth_enable);
+	struct net *net = current->nsproxy->net_ns;
 	struct ctl_table tbl;
 	bool changed = false;
 	char *none = "none";


