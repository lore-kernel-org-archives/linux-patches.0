Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B6C1D1510;
	Wed,  2 Oct 2024 14:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879086; cv=none; b=fHgW6QWJf5pO4YiMx0Kx5wLaGmGfI3U6q0lD8Ru9HY3D6GjoXwynCGT2ajJm+BwgjviFPw2fxdv/9IjodhtdcduiNvGGkzVQknSCtcsJIpbDuLg9dKx6XM/StCHcSbXiWeU1uTayoCWt6kLh41dzFkJiEzIewwbZwfc8Qb2wF5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879086; c=relaxed/simple;
	bh=o+ScdfwVI18bBf1zH9L+idOi8TYdRYGPArw2Ah3jBpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXI31ea4x5EVB80QtKMgJdzxkes92AvjZEivyoVc4UbklHVYaFUrA+np4P9pEADWgwBCH5bfdgvSU8Lv0UrzSltmg3nM7EYfXBp9QEFBqRima5dZHlOMzhpHd/hrvpkqXkc9OGvWYMNmUxyYyNt4JfEamOK1xjYFwAIlVUKCaAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHPO5aBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHPO5aBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92BC0C4CEC2;
	Wed,  2 Oct 2024 14:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879086;
	bh=o+ScdfwVI18bBf1zH9L+idOi8TYdRYGPArw2Ah3jBpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHPO5aBi9O4gIj8LNim1vNN0/NC5mZoZoLCZwaL6DNNbnwDxZUwvgHzLgTz3jtr8/
	 Lhp9fisrviRPqf2CODRQvTTr97NlkgML0seLczS4GlYlznUJI4CQhIAzSSkZSDdKUx
	 5Rv6Jk5+K4QBJGmzEdwRhnkjVUjlbVONBXHx0PgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.10 633/634] Documentation: KVM: fix warning in "make htmldocs"
Date: Wed,  2 Oct 2024 15:02:13 +0200
Message-ID: <20241002125836.112711911@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

commit efbc6bd090f48ccf64f7a8dd5daea775821d57ec upstream.

The warning

 Documentation/virt/kvm/locking.rst:31: ERROR: Unexpected indentation.

is caused by incorrectly treating a line as the continuation of a paragraph,
rather than as the first line in a bullet list.

Fixed: 44d174596260 ("KVM: Use dedicated mutex to protect kvm_usage_count to avoid deadlock")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/virt/kvm/locking.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -25,6 +25,7 @@ The acquisition orders for mutexes are a
   must not take either kvm->slots_lock or kvm->slots_arch_lock.
 
 cpus_read_lock() vs kvm_lock:
+
 - Taking cpus_read_lock() outside of kvm_lock is problematic, despite that
   being the official ordering, as it is quite easy to unknowingly trigger
   cpus_read_lock() while holding kvm_lock.  Use caution when walking vm_list,


