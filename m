Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3FE14AD12;
	Tue, 20 Feb 2024 21:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463341; cv=none; b=AERO83WUpYN3sKt+2+bpsMMRx4pNEWEL9qfs/YLz8vJ/LpHUjUhnP8pmlj1YHt/5T57HMZLf5sWcIyexw5U3nZkbo62xtjhCehUvxcIitqjnZ9sauxYBIu4AToHxDGOl+8GUQz91nz5mLvmiphb5cBfLJ5lOiAcT06sJLefRt/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463341; c=relaxed/simple;
	bh=7b2LDCpUhG0FeIg0CxaOktk5HFOljrrqArl4+gRMXos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzQoJ//x8eNmiOeSVIATodw0oLzmKagnKCax0q+UHq9OnunBxZYx/ty5XL17dp+dz3N4ohT+2s6E1BdgHJgBFyqnfKs6NporACVE+prZE7Bx7Zjy0B9WM3piABxB+3j4iwMKu1DK/akWVJlkcnfNQ1Zp9kj02orIelLw9lJba/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IOfLfmQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IOfLfmQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8726DC433F1;
	Tue, 20 Feb 2024 21:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463341;
	bh=7b2LDCpUhG0FeIg0CxaOktk5HFOljrrqArl4+gRMXos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOfLfmQRMbwoPg3udDUqBjmb5zNgZmsZf2yppMv6zXbftrYVKwyfor8CKI8oC8ZG2
	 qCPm9fizKKB3o5uwswYdHWeHjdghZ4glkXDNPqqWDGWLjVhlWSpx2HGoAgPwGNizcT
	 ULCdJjGwD3YIeJRDqHTDlvgBvAgL6FAhAP8GEHD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 014/331] KVM: selftests: Delete superfluous, unused "stage" variable in AMX test
Date: Tue, 20 Feb 2024 21:52:10 +0100
Message-ID: <20240220205638.031119383@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 46fee9e38995af9ae16a8cc7d05031486d44cf35 ]

Delete the AMX's tests "stage" counter, as the counter is no longer used,
which makes clang unhappy:

  x86_64/amx_test.c:224:6: error: variable 'stage' set but not used
          int stage, ret;
              ^
  1 error generated.

Note, "stage" was never really used, it just happened to be dumped out by
a (failed) assertion on run->exit_reason, i.e. the AMX test has no concept
of stages, the code was likely copy+pasted from a different test.

Fixes: c96f57b08012 ("KVM: selftests: Make vCPU exit reason test assertion common")
Reviewed-by: Jim Mattson <jmattson@google.com>
Link: https://lore.kernel.org/r/20240109220302.399296-1-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/x86_64/amx_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 11329e5ff945..309ee5c72b46 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -221,7 +221,7 @@ int main(int argc, char *argv[])
 	vm_vaddr_t amx_cfg, tiledata, xstate;
 	struct ucall uc;
 	u32 amx_offset;
-	int stage, ret;
+	int ret;
 
 	/*
 	 * Note, all off-by-default features must be enabled before anything
@@ -263,7 +263,7 @@ int main(int argc, char *argv[])
 	memset(addr_gva2hva(vm, xstate), 0, PAGE_SIZE * DIV_ROUND_UP(XSAVE_SIZE, PAGE_SIZE));
 	vcpu_args_set(vcpu, 3, amx_cfg, tiledata, xstate);
 
-	for (stage = 1; ; stage++) {
+	for (;;) {
 		vcpu_run(vcpu);
 		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
 
-- 
2.43.0



