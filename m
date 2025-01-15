Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CC6156644;
	Wed, 15 Jan 2025 10:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938305; cv=none; b=fFbHK8G2AE8D17BvM77cdqITDF2Uhb1nOoLkq+54z+vHhQjLPqJ+7cmABfYakYuNnT08zO2F0p8K74iIthyzUJYQcF1XT6eeOisXj/MmR2vJyNA/agVFN5IMqwMEqpfRoHDQ3+bya2KEkK7oQBtrXa9IIelKf3gzM/mFBlUHwJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938305; c=relaxed/simple;
	bh=3jLGme07+Zjw+TO1c44jG8JtPppcwJhSxgKbZQkge30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+MYNok5XU17ttgnR/ZOI+4vGC5wBSdPAf3H/SDa4ablloK6Onkpou+wTmECj2FJswFNoay28YKdO2iswAosr8RgfSjxnSKW2Ae1d4Q711JMNYA8lGyATrlIN5RGhETfxLFUt0tPS2k518pHQYNxRhwg8hI4yXPXUwUpeza8rqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvhrwLkz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvhrwLkz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49F0C4CEDF;
	Wed, 15 Jan 2025 10:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938305;
	bh=3jLGme07+Zjw+TO1c44jG8JtPppcwJhSxgKbZQkge30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvhrwLkzrTE930TvnhAIvpic0OicJCg7BDg+MzuiYI6KMne4qGUivZnbw+fx4fBf8
	 2oyC+blD+L2BWgKYzxZp54ZkfCj+8AVh2GBuxWbHJZfVr5RqAxQlb3QK3aO4KTQqHP
	 dmCA+g6Z7Q3ovVu13VG02lwpNFbTi+RQSAeGBjZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <quic_prashk@quicinc.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.12 144/189] usb: dwc3-am62: Disable autosuspend during remove
Date: Wed, 15 Jan 2025 11:37:20 +0100
Message-ID: <20250115103612.167549504@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <quic_prashk@quicinc.com>

commit 625e70ccb7bbbb2cc912e23c63390946170c085c upstream.

Runtime PM documentation (Section 5) mentions, during remove()
callbacks, drivers should undo the runtime PM changes done in
probe(). Usually this means calling pm_runtime_disable(),
pm_runtime_dont_use_autosuspend() etc. Hence add missing
function to disable autosuspend on dwc3-am62 driver unbind.

Fixes: e8784c0aec03 ("drivers: usb: dwc3: Add AM62 USB wrapper driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Prashanth K <quic_prashk@quicinc.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/20241209105728.3216872-1-quic_prashk@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-am62.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/dwc3/dwc3-am62.c
+++ b/drivers/usb/dwc3/dwc3-am62.c
@@ -309,6 +309,7 @@ static void dwc3_ti_remove(struct platfo
 
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
+	pm_runtime_dont_use_autosuspend(dev);
 	pm_runtime_set_suspended(dev);
 }
 


